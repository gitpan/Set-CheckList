package Set::CheckList;
use strict;
use Carp;
use vars '$VERSION';

# version
$VERSION = '1.00';


=head1 NAME

Set::CheckList - Keep track of a list of "to do" items

=head1 SYNOPSIS

 use Set::CheckList;
 my ($checklist, $item);

 $checklist = Set::CheckList->new();
 $checklist->set('Fred');

 while (defined($item = $cl->next())) {
    # items can be set in the middle of a loop
    $checklist->set('Wilma');
    
    # setting an item again doesn't change its done status
    $checklist->set('Fred');
    
    print $item, "\n"
 }


=head1 INSTALLATION

Set::CheckList can be installed with the usual routine:

	perl Makefile.PL
	make
	make test
	make install

You can also just copy CheckList.pm into the Set/ directory of one of your library trees.

=head1 DESCRIPTION

Set::CheckList provides a mechanism for tracking a list of "to do" items.  Each item can be added to the list any 
number of times, but is returned only once by the next() command.

Items are added using C<set()>.  The first argument for C<set()> is the name (i.e. the key) of the item.  
If C<set()> is called w/o any further arguments then CheckList only adds the item if it is not already 
in the list.  If the second argument is C<0>, then the item in the list is marked as false (not done).  
If the second argument is C<1>, then the item in the list is marked as true (done).  

=head1 METHODS

=cut


#--------------------------------------------------------------
# new
# 

=head2 Set::CheckList->new()

The C<new> method returns a new Set::CheckList object.  C<new> uses no arguments.

   $checklist = Set::CheckList->new;

=cut

sub new {
	my ($class) = @_;
	my $self = bless({}, $class);
	
	# properties
	$self->clear;
	
	return $self;
}
# 
# new
#--------------------------------------------------------------


#--------------------------------------------------------------
# set
# 

=head2 $checklist->set(key [, value])

Ensures that the given name is in the list.  If a value is B<not> given as the first argument, and the item 
is already in the list, the item's done status is not changed, otherwise the item is added with a done status 
of false. If value is given, sets the item to the given value (true or false).  

 # ensure the item is in the list,
 # but don't change its value if is
 # already there
 $checklist->set('Larry');

 # ensure the item is in the list,
 # and set its value to done
 $checklist->set('Larry', 1);

=cut

sub set {
	my ($self, $key, $value) = @_;
	my $items = $self->{'items'};
	
	if ($value)
		{$items->{$key} = 1}
	
	elsif (defined($value) || (! exists $items->{$key}) )
		{$items->{$key} = 0}
}
# 
# set
#--------------------------------------------------------------


#--------------------------------------------------------------
# next
# 

=head2 $checklist->next([autocheck])

Returns the next not-done value in the list. Returns undef if all are done. By default, 
C<next> automatically marks the returned item as true.  Therefore you can simply loop through 
the list by repeatedly calling next:

 while (defined($item = $cl->next()))
    {print $item, "\n"}

If the first argument is defined but false, C<next> does not mark the next item as done.
If you send true as the first argument then the item is marked as done.

C<next> does not return items in any particular order.

=cut

sub next {
	my ($self, $autocheck) = @_;
	
	defined($autocheck) or $autocheck = 1;
	
	foreach my $key (keys %{$self->{'items'}}) {
		if (! $self->{'items'}->{$key}) {
			$autocheck and $self->{'items'}->{$key} = 1;
			return $key;
		}
	}
	
	return undef;
}
# 
# next
#--------------------------------------------------------------


#--------------------------------------------------------------
# clear
# 

=head2 $checklist->clear()

C<clear> clears out all items from the list:

  $checklist->clear();

=cut

sub clear {
	my ($self) = @_;
	$self->{'items'} = {};
}
# 
# clear
#--------------------------------------------------------------


#--------------------------------------------------------------
# reset
# 

=head2 $checklist->reset([status])

C<reset> resets the done status of all items in the list.  

  $checklist->reset

The first and only argument indicates if they should be set
to done (true) or not done (false).  So, for example, the
following command resets all items to done:

  $checklist->reset(1);

=cut

sub reset {
	my ($self, $value) = @_;
	$value = $value ? 1 : 0;
	
	foreach my $key (keys %{$self->{'items'}})
		{$self->{'items'}->{$key} = $value}
}
# 
# reset
#--------------------------------------------------------------


# return true
1;

__END__

=head1 TERMS AND CONDITIONS

Copyright (c) 2002 by Miko O'Sullivan.  All rights reserved.  This program is free
software; you can redistribute it and/or modify it under the same terms as Perl itself.  

This software comes with B<NO WARRANTY> of any kind.

=head1 AUTHOR

Miko O'Sullivan
F<miko@idocs.com>

=head1 VERSION

Version 1.00    July 10, 2002

=cut

