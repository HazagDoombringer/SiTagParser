#!/usr/bin/perl
#Version 28022018:1223
# use strict;
use warnings;

#ça va utiliser de l'objet en masssssssss s
use HTML::TagParser;
# use HTML::TreeBuilder;    #not used 
use Class::CSV;


#CSV values -> test only by now 
open(CSV,">Output.csv") or die "can't create an output.csv file\n";
my $csv = Class::CSV->new(
    fields => [qw/question answer/]
);



open(MD,">Output.md") or die "can't create an output.md file\n";
open(FILE,">Output.txt") or die "can't create an output.txt file\n";


my $check = scalar(grep $_,@ARGV) or die "ERROR :: NO ARGUENT FOUND\n";
my $CSVquestion;
my $CSVanswer;

foreach my $ARGC (@ARGV){
    my $url  = $ARGC;
    my $html = HTML::TagParser->new( $url );                    #new html parser object 
    my @list = $html->getElementsByClassName( "tabG4_ligne" );  #get a list of < XX class = tabG4_ligne>XX</tabG4_ligne>
    myDprint("\n\n\t$ARGC\n\n");
    foreach my $elem ( @list ) {
        my $text = $elem->innerText;                            #get text inside of html 
        if($text =~ m#^\d{4,6}#){
#             myDprint ("\"$text\"\n");
            
            
            myDprint ("_" x 20);
            myDprint ("\n\n\n## QUESTION:");
            my @question = split(/\n/,$text);
            $CSVquestion = "@question";
            foreach my $line (@question){
                $line =~ s/\s{2,}//;
#                 myDprint ("$line ");
            }
            $text = join (" ",@question);
            $text =~ s/(.*?\?).*/$1/;                           # get everithing before char: '?' 
            myDprint ("$text\n");
            myDprint ("\n" x 2);
        }
        elsif($text eq "ajouter une nouvelle reponse"){
            #osef
        }
        elsif($text =~ /^[1-9]/){                               #ligne a modifié en fonction du barème du QCM
            myDprint ("**REPONSE:** *$text*\n");
            $CSVanswer = $text;
            
        }
        else{
#         print "$text\n";
        }
    }
}
print "\t--> Done\n";

# $csv->add_line({
#     question    =>  "$CSVquestion",
#     answer      =>  "$CSVanswer"
# });
# $csv->print();


close FILE;
close MD;
close CSV;

exit 0;
sub myDprint {
    (my $input) = @_;
#     print "$input";
    print FILE "$input";
    print MD "$input";
}
