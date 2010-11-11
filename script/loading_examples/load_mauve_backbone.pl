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

Usage: $0 -file <tab delimited blast file to parse> -exp_name = <your_exp_name>

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
my $pidt = $mb->resultset('LocMetadataType')->find_or_create({name=>'Percent ID'}) if $go;


process_file(file=>$file, exp=>$exp);

sub process_file
  {
    my %opts = @_;
    my $file = $opts{file}; #file name
    my $exp=$opts{exp}; #experiment db object
    my $org_names = $opts{org_names}; #array of org_names in order from file

    #mauve's backbone file  taken from: http://asap.ahabs.wisc.edu/mauve-aligner/mauve-user-guide/mauve-output-file-formats.html
# The original Mauve backbone file

# The .backbone file records regions of the alignment where sequence is conserved among all of the genomes being aligned. The current Mauve implementation defines a conserved region as an area of the alignment at least x nucleotides long that contains no gaps as long or longer than y nucleotides. When using the Align sequences window to perform an alignment, the values of x and y are fixed to the minimum island size. These values can be set explicitly using the command-line mauveAligner application.

# Each line of the .backbone file records a single conserved segment. Left and right end coordinates of the conserved segment are given for each genome sequence. For example, the line:

# 22256 22371 20147 20299 22255 22370

# Would indicate that nucleotides 22,256 through 22,371 from the first genome are conserved in the second and third genomes from 20,145 through 20,299, and 22,255 through 22,370 respectively. Two entries exist per genome, and each entry is tab-delimited. Negative valued coordinates indicate an inverted region (on the opposite strand).
# The Progressive Mauve backbone file

# Progressive Mauve utilizes a revised backbone file format which reflects its ability to align regions conserved among subsets of the genomes under study.  A short example of the backbone file format is:

# seq_0_leftend seq_0_rightend seq_1_leftend seq_1_rightend seq_2_leftend seq_2_rightend
# 1             15378          1             15377          1             15377
# 16728         19795          15378         18446          15378         18445
# 0             0              18447         18668          18446         18667
# 19796         20566          18669         19439          18668         19438

# The first line is a header line, indicating the information contained by each column.  Each subsequent line corresponds to a segment of DNA conserved among two or more genomes.  Thus, the first line indicates that the segment between coordinates 1 and 15378 in the first genome is homologous to the segment between coordinates 1 and 15377 of the second and third genomes.  Similarly, the second line indicates that the segment [16728-19795] in the first genome is homologous to [15378-18446] in the second genome and [15378-18445] in the third genome. 

# An island exists in the first genome between [15379-16727], and its existence is given in the backbone file as a lack of any line containing that segment.  The seq_0_rightend column skips from 15378 on line 1 to 16728 on line two.  By default, the rows of the backbone file are sorted on the seq_0_leftend column (absolute value).  To infer islands in seq 0, we can thus simply compare the rightend of one line to the leftend from the subsequent line. The data can be trivially processed to observe islands in other genomes using a spreadsheet program like OpenOffice Calc or MS Excel.  Simply sort the rows on the absolute value of the column for a sequence (e.g. seq_2_leftend) and then compare right-end to left-end on the subsequent line.

# An island (or subset backbone) also exists in the second and third genomes.  The existence of the subset backbone is given on the third line, where seq_0_leftend and seq_0_rightend both have zero values to indicate that the first genome lacks any detectable homology to the segments [18447-18668] in the second genome and [18446-18667] in the third genome.    

    open (IN, $file) || die "Can't read $file: $!";
    my $count = 0;
    while (<IN>)
      {
	print "processed $count loc sets\n" unless $count%1000;
	chomp;
	next if /^seq/;
	next unless $_;
	my @pairs;
	my $org_id =0;
	while (/(-?\d+)\s+(-?\d+)/g)
	  {
	    my ($start, $stop) = ($1, $2);
	    #according to mauve's docs above, if start/stop are negative, orientation is on the opposite strand
	    my $ori = $start=~/-/ ? -1 : 1;
	    $start =~ s/-//g;
	    $stop =~ s/-//g;
	    push @pairs, [$start,$stop, $ori, $org_id];
	    $org_id++;
	  }

	#create loc set for experiment.  Name based on line count in file as each line is a loc set
	print "Creating loc_set: $count\n" if $DEBUG;
	my $loc_set = $exp->add_to_loc_sets({name=> "Block: $count"}) if $go;

	foreach my $pair (@pairs)
	  {
	    my ($start, $stop, $ori, $org_id) = @$pair;

	    #have org name?  if not, fake it.
	    my $org_name = $org_names->[$org_id] ? $org_names->[$org_id] : "Organism $org_id";
	    #skip locs without positions
	    next unless $start && $stop;
	    #add loc to loc set
	    print "\t", join ("\t", $start, $stop, $ori, $org_name),"\n" if $DEBUG;
	    my $loc =  $loc_set->add_to_locs({
					      start=>$start,
					      stop=>$stop,
					      orientation=>$ori,
					      linear_coordinate_object_id=>$org_name,
					     }) if $go;
	    
	  }
	$count++;
      }
    close IN;
  }
