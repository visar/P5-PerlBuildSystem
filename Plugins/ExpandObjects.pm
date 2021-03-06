
=head1 Plugin  ExpandObjects

Expand /objects in %DEPENDENCY_LIST_EXPANDED

=cut

use PBS::Output;
use PBS::SubpbsResult ;

use Data::TreeDumper ;

#-------------------------------------------------------------------------------

sub EvaluateShellCommand
{
my ($shell_command_ref, $tree, $dependencies, $triggered_dependencies) = @_ ;

my $evaluate_shell_command_verbose = $tree->{__PBS_CONFIG}{EVALUATE_SHELL_COMMAND_VERBOSE} ;

if($evaluate_shell_command_verbose)
	{
	PrintDebug "'ExpandObjects' plugin handling '$tree->{__NAME}' shell command:\n\t$$shell_command_ref\n" ;
	}

if($$shell_command_ref =~ /([^\s]+)?\%DEPENDENCY_LIST_OBJECTS_EXPANDED/)
	{
	my $expanded_dependency_list = '' ;
	
	for my $dependency (@$dependencies)
		{
		if($dependency =~ /\.objects$/)
			{
			$expanded_dependency_list .= ' ' . join(' ', GetFiles(new PBS::SubpbsResult($dependency))) ;
			}
		else
			{
			$expanded_dependency_list .= ' ' . $dependency ;
			}
		}
	
	$$shell_command_ref =~ s/\%DEPENDENCY_LIST_OBJECTS_EXPANDED/$expanded_dependency_list/g ;
	}
	
PrintDebug "\t=> $$shell_command_ref\n\n" if($evaluate_shell_command_verbose) ; 
}

sub GetFiles
{
# extract files from fileAndMd5 class

my ($subpbs_result) = @_ ;

return
	(
	map{$_->{FILE}} @{ $subpbs_result->GetFileAndMd5()}
	) ;
}

#-------------------------------------------------------------------------------

1 ;

