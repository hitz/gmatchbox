#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Getopt::Long;
use Gmatchbox::Model::DB;
use Gmatchbox;
use vars qw($DEBUG $help $file $exp_name $exp_desc $mb $algo_name $go);

GetOptions(
           "file|f=s"=>\$file,
           "help|h"=>\$help,
           "exp_name=s"=>\$exp_name,
           "exp_desc=s"=>\$exp_desc,
           "algo_name=s"=>\$algo_name,
	   "go"=>\$go,
	   "debug=i"=>\$DEBUG,
          );


$algo_name = "Mauve" unless $algo_name;
$help = 1 unless $file;
$help = 1 unless $exp_name;
if ($help)
  {
    print qq{
Welcome to $0.

Usage: $0 -file <path/name of mauve.xmfa file to parse> -exp_name = <your_exp_name>

OPTIONS:
 -file | -f         name of file with blast hits in tabular format
 
 -exp_name          name of experiment

 -exp_desc          description of experiment

 -algo_name         Name of algorithm used in blast comparison (DEFAULT: MegaBlast)
};
    exit();
  }

$mb = Gmatchbox::Model::DB->new;
$mb->connect("dbi:mysql::dbname=gmatchbox;host=localhost;port=3307");

#creating the experiemnt database entry and object
my $exp = $mb->resultset('Experiment')->find_or_create({name=>$exp_name, description=>$exp_desc}) if $go;

#need experiment metadata type for "algorithm"

my $exp_mdt = $mb->resultset('ExperimentMetadataType')->find_or_create({name=>'Algorithm'}) if $go;
#add experiment algorithm to experiment
$exp->add_to_experiment_metadatas({value=>"$algo_name", experiment_metadata_type_id=>$exp_mdt->id}) if $go;

#create metadata type for locs
my $alnt = $mb->resultset('LocMetadataType')->find_or_create({name=>'Alignment'}) if $go;


process_file(file=>$file, exp=>$exp);

sub process_file
  {
    my %opts = @_;
    my $file = $opts{file}; #file name
    my $exp=$opts{exp}; #experiment db object
    open (IN, $file) || die "Can't read $file: $!";
    my $count = 0;
    my $seq_file_names;#to store sequence file names from header of xmfa files
    $/="=\n"; #redefined record input separator for break between syntenic blocks in xmfa files
    while (my $section = <IN>)
      {
	print "processed $count loc sets\n" unless $count%1000;
	if ($section =~ /^#/)
	  #in header.  Extract file names;
	  {
	    $seq_file_names = parse_file_names($section);
	  }
	my $loc_set_data = process_seqs ($section);
	
	#create loc set for experiment.  Name based on line count in file as each line is a loc set
	print "\n";
	print "Creating loc_set: $count\n" if $DEBUG;
	
	my $loc_set = $exp->add_to_loc_sets({name=> "Block: $count"}) if $go;
	foreach my $org_num  (keys %$loc_set_data)
	  {
	    my $org_name = $seq_file_names->{$org_num};
	    my ($start, $stop, $ori, $aln) = @{$loc_set_data->{$org_num}};
	    print $aln,"\n" if $DEBUG > 1;
	    #skip locs without positions
	    next unless $start && $stop;
	    #add loc to loc set
	    print "\t", join ("\t", $start, $stop, $ori, $org_name, length ($aln)),"\n" if $DEBUG;
	    my $loc =  $loc_set->add_to_locs({
					      start=>$start,
					      stop=>$stop,
					      orientation=>$ori,
					      linear_coordinate_object_id=>$org_name,
					     }) if $go;
	    #add alignment to loc's metadata
	    $loc->add_to_loc_metadatas({
					value=>$aln,
					loc_metadata_type_id=>$alnt->id
				       }) if $go;
	  }
	$count++;
      }
    close IN;
  }


sub parse_file_names
    {
      my $stuff = shift;
      my %seq_file_names;
      foreach (split/\n/, $stuff)
	{
	  chomp;
	  next unless $_;
	  #capture file names
	  if (/#Sequence(\d+)File\s+(\S+)/)
	    {
	      $seq_file_names{$1}=$2;
	    }
	  last if /^>/;
	}
      return \%seq_file_names;

    }

sub process_seqs
    {
      my $seqs = shift;
      $seqs =~ s/#.*?\n//g; #remove comments
      my %data;
      #get each sequence
      foreach my $item (split /\n>/, $seqs)
	{
	  $item =~ s/>//g;#remove the header ">"
	  $item =~ s/=//g;#remove the xmfa aligment block delimiter
	  my ($head, $seq) = split /\n/, $item, 2;
	  $seq =~ s/\n//g;
	  my ($org_num, $start, $stop, $ori) = $head =~ /(\d+):(\d+)-(\d+)\s(.)/;
	  #ori is expressed as a "+" or "-", convert to "1"; "-1" respectively
	  $ori = $ori =~ /-/ ? -1 : 1;
	  #skip stuff w/o alignment
	  next unless $start && $stop;
	  $data{$org_num} = [$start, $stop, $ori, $seq];
	}
      return \%data;
    }
