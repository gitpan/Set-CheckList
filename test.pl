#!/usr/local/bin/perl -w
use strict;
#use lib '../../';
use Set::CheckList;
use Test;

BEGIN { plan tests => 3 };

# useful for all tests
my (@names, $sorted);
@names = ('Fred', 'Barney', 'Wilma');
$sorted = join('', sort @names);


#---------------------------------------------------------
# basic tests
# 
{
	my ($checklist, @items);
	
	$checklist = Set::CheckList->new();
	$checklist->set($names[0]);
	
	while (defined(my $item = $checklist->next())) {
		foreach my $name (@names)
			{$checklist->set($name)}
		
		push @items, $item;
	}
	
	err_comp('basic test', $sorted, join('', sort @items));
}
# 
# basic tests
#---------------------------------------------------------


#---------------------------------------------------------
# clear
# 
{
	my ($checklist, @items);
	
	$checklist = Set::CheckList->new();
	
	foreach my $name (@names)
		{$checklist->set($name)}
	
	$checklist->clear;
	
	err_comp('basic test', '', join('', values %{$checklist->{'items'}}));
}
# 
# clear
#---------------------------------------------------------


#---------------------------------------------------------
# reset
# 
{
	my ($checklist, @items);
	
	$checklist = Set::CheckList->new();
	
	foreach my $name (@names)
		{$checklist->set($name)}
	
	$checklist->reset(1);
	
	err_comp('basic test', '1' x @names, join('', values %{$checklist->{'items'}}));
}
# 
# reset
#---------------------------------------------------------


#------------------------------------------------------
# err_comp
#
sub err_comp {
	my ($testname, $is, $should) = @_;
	
	if($is ne $should) {
		print STDERR 
			"\n", $testname, "\n",
			"\tis:     $is\n",
			"\tshould: $should\n\n";	
		ok(0);
	}
	
	else
		{ok(1)}
}
#
# err_comp
#------------------------------------------------------

