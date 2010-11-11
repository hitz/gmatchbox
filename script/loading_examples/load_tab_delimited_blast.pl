#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Getopt::Long;
use Gmatchbox::Model::DB;
use Gmatchbox;
use vars qw($DEBUG $help $file $exp_name $exp_desc $mb $algo_name);

GetOptions(
	   "file|f=s"=>\$file,
	   "help|h"=>\$help,
	   "exp_name=s"=>\$exp_name,
	   "exp_desc=s"=>\$exp_desc,
	   "algo_name=s"=>\$algo_name,
	  );


$algo_name = "MegaBlast" unless $algo_name;
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

 -algo_name	    Name of algorithm used in blast comparison (DEFAULT: MegaBlast)
};
    exit();
  }

$mb = Gmatchbox::Model::DB->new;
$mb->connect("dbi:mysql::dbname=gmatchbox;host=localhost;port=3307");

#creating the experiemnt database entry and object
my $exp = $mb->resultset('Experiment')->find_or_create({name=>$exp_name, description=>$exp_desc});

#need experiment metadata type for "algorithm"

my $exp_mdt = $mb->resultset('ExperimentMetadataType')->find_or_create({name=>'Algorithm'});
my $pidt = $mb->resultset('LocMetadataType')->find_or_create({name=>'Percent ID'});
my $alt = $mb->resultset('LocMetadataType')->find_or_create({name=>'Alignmnt Length'});
my $mmt = $mb->resultset('LocMetadataType')->find_or_create({name=>'MisMatches'});
my $got = $mb->resultset('LocMetadataType')->find_or_create({name=>'Gap Openings'});
my $evt = $mb->resultset('LocMetadataType')->find_or_create({name=>'E-value'});
my $bst = $mb->resultset('LocMetadataType')->find_or_create({name=>'Bit Score'});

$exp->add_to_experiment_metadatas({value=>"$algo_name", experiment_metadata_type_id=>$exp_mdt->id});




process_file(file=>$file, exp=>$exp);



sub process_file
  {
    my %opts = @_;
    my $file = $opts{file};
    my $exp=$opts{exp};
    my %data;
    open (IN, $file) || die "Can't open $file for reading: $!";
# Blast tabular output
# 0. Query
# 1. Subject
# 2. % id
# 3. aligment length
# 4. mismatches
# 5. gap openings
# 6. q.start
# 7. q.end
# 8. s.start
# 9. s.edu
# 10. e-value
# 11. bit score
    my $i = 1;
    while (<IN>)
      {
	print "processing line $i\n" unless $i%1000;
	chomp;
	next unless $_;
	my ($query, $subject, $pid, $al, $mm, $go, $qstart, $qstop, $sstart, $sstop, $eval, $bitscore) = split /\t/, $_;
	#spoof for getting ori. This information is in subject name by having a strand of -1
	my $ori = $subject =~ /-/ ? -1 : 1;

	#create loc set
	my $loc_set = $exp->add_to_loc_sets({name=>"hit $i"});

	#create loc for query
	my $qloc = $loc_set->add_to_locs({
					  start=>$qstart,
					  stop=>$qstop,
					  orientation=>$ori,
					  linear_coordinate_object_id=>$query,
					 });

	#create loc for subject
	my $sloc = $loc_set->add_to_locs({
					  start=>$sstart,
					  stop=>$sstop,
					  orientation=>$ori,
					  linear_coordinate_object_id=>$subject,
					 });
	#populat values with appropriate metatdata types for loc
	$qloc->add_to_loc_metadatas({
				   value=>$pid,
				   loc_metadata_type_id=>$pidt->id
				   });
	$qloc->add_to_loc_metadatas({
				   value=>$al,
				   loc_metadata_type_id=>$alt->id
				   });
	$qloc->add_to_loc_metadatas({
				   value=>$mm,
				   loc_metadata_type_id=>$mmt->id
				   });
	$qloc->add_to_loc_metadatas({
				   value=>$go,
				   loc_metadata_type_id=>$got->id
				   });
	$qloc->add_to_loc_metadatas({
				   value=>$eval,
				   loc_metadata_type_id=>$evt->id
				   });
	$qloc->add_to_loc_metadatas({
				   value=>$bitscore,
				   loc_metadata_type_id=>$bst->id
				   });

	$sloc->add_to_loc_metadatas({
				   value=>$pid,
				   loc_metadata_type_id=>$pidt->id
				   });
	$sloc->add_to_loc_metadatas({
				   value=>$al,
				   loc_metadata_type_id=>$alt->id
				   });
	$sloc->add_to_loc_metadatas({
				   value=>$mm,
				   loc_metadata_type_id=>$mmt->id
				   });
	$sloc->add_to_loc_metadatas({
				   value=>$go,
				   loc_metadata_type_id=>$got->id
				   });
	$sloc->add_to_loc_metadatas({
				   value=>$eval,
				   loc_metadata_type_id=>$evt->id
				   });
	$sloc->add_to_loc_metadatas({
				   value=>$bitscore,
				   loc_metadata_type_id=>$bst->id
				   });

	$i++;
      }
    close IN;
    return \%data;
  }


sub create_tables
  {
my $exp = qq{
CREATE TABLE IF NOT EXISTS `experiment` (
  `experiment_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(1054) DEFAULT NULL,
  PRIMARY KEY (`experiment_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
};

my $exp_md = qq{
CREATE TABLE IF NOT EXISTS `experiment_metadata` (
  `experiment_metadata_id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(1054) NOT NULL,
  `experiment_id` int(11) NOT NULL,
  `experiment_metadata_type_id` int(11) NOT NULL,
  PRIMARY KEY (`experiment_metadata_id`),
  KEY `experiment_id` (`experiment_id`),
  KEY `experiment_metadata_type_id` (`experiment_metadata_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
};

my $exp_md_type = qq{
CREATE TABLE IF NOT EXISTS `experiment_metadata_type` (
  `experiment_metadata_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` varchar(1054) DEFAULT NULL,
  PRIMARY KEY (`experiment_metadata_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
};

my $loc = qq{
CREATE TABLE IF NOT EXISTS `loc` (
  `loc_id` int(12) NOT NULL AUTO_INCREMENT,
  `start` int(12) NOT NULL,
  `stop` int(12) NOT NULL,
  `orientation` int(2) NOT NULL,
  `loc_set_id` int(11) NOT NULL,
  `linear_coordinate_object_id` int(12) DEFAULT NULL,
  PRIMARY KEY (`loc_id`),
  KEY `start` (`start`),
  KEY `stop` (`stop`),
  KEY `orientation` (`orientation`),
  KEY `linear_coordinate_object_id` (`linear_coordinate_object_id`),
  KEY `loc_set_id` (`loc_set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;
};
  }
