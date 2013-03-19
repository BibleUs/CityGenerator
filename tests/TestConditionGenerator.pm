#!/usr/bin/perl -wT
###############################################################################
#
package TestConditionGenerator;

use strict;
use Test::More;
use ConditionGenerator;
use GenericGenerator qw( set_seed );

use Data::Dumper;
use XML::Simple;
use vars qw(@ISA @EXPORT_OK $VERSION $XS_VERSION $TESTING_PERL_ONLY);
require Exporter;

@ISA       = qw(Exporter);
@EXPORT_OK = qw( );


subtest 'test create_condition' => sub {
    my $condition;
    set_seed(1);
    $condition=ConditionGenerator::create_condition();
    is($condition->{'seed'},41630);
    is(Dumper($condition->{'pop_mod'}),Dumper( {}) );
    is(Dumper($condition->{'bar_mod'}),Dumper( {}) );

    $condition=ConditionGenerator::create_condition({'seed'=>12345, 'pop_mod'=>{'foo'=>1},'bar_mod'=>{'foo'=>1}});
    is($condition->{'seed'},12345);
    is(Dumper($condition->{'pop_mod'}),Dumper( {'foo'=>1}) );
    is(Dumper($condition->{'bar_mod'}),Dumper( {'foo'=>1}) );

    $condition=ConditionGenerator::create_condition({'seed'=>12345, 'pop_mod'=>[],'bar_mod'=>1});
    is($condition->{'seed'},12345);
    is(Dumper($condition->{'pop_mod'}),Dumper( {}) );
    is(Dumper($condition->{'bar_mod'}),Dumper( {}) );


    done_testing();
};

subtest 'test set_time' => sub {
    my $condition;
    set_seed(1);
    $condition={'seed'=>40};
    ConditionGenerator::set_time($condition);
    is($condition->{'seed'},40);
    is($condition->{'time_description'},'at daybreak');
    is($condition->{'time_exact'},'07:52');
    is($condition->{'time_pop_mod'},1);
    is($condition->{'time_bar_mod'},0);
    is(Dumper($condition->{'pop_mod'}),Dumper( {'time'=>'1'}) );
    is(Dumper($condition->{'bar_mod'}),Dumper( {'time'=>'0'}) );

    $condition={'seed'=>40, 'time_description'=>'foo1','time_exact'=>'foo2','time_pop_mod'=>'foo3','time_bar_mod'=>'foo4' };
    ConditionGenerator::set_time($condition);
    is($condition->{'seed'},40);
    is($condition->{'time_description'},'foo1');
    is($condition->{'time_exact'},'foo2');
    is($condition->{'time_pop_mod'},'foo3');
    is($condition->{'time_bar_mod'},'foo4');
    is(Dumper($condition->{'pop_mod'}),Dumper( {'time'=>'foo3'}) );
    is(Dumper($condition->{'bar_mod'}),Dumper( {'time'=>'foo4'}) );

    done_testing();
};

subtest 'test set_temp' => sub {
    my $condition;
    set_seed(1);
    $condition={'seed'=>40};
    ConditionGenerator::set_temp($condition);
    is($condition->{'seed'},40);
    is($condition->{'temp_description'},'unbearably cold');
    is($condition->{'temp_pop_mod'},'0.10');

    $condition={'seed'=>40, 'temp_description'=>'foo1','temp_pop_mod'=>'foo2' };
    ConditionGenerator::set_temp($condition);
    is($condition->{'seed'},40);
    is($condition->{'temp_description'},'foo1');
    is($condition->{'temp_pop_mod'},'foo2');

    done_testing();
};

subtest 'test set_air' => sub {
    my $condition;
    set_seed(1);
    $condition={'seed'=>40};
    ConditionGenerator::set_air($condition);
    is($condition->{'seed'},40);
    is($condition->{'air_description'},'fresh');
    is($condition->{'air_pop_mod'},'1.10');

    $condition={'seed'=>40, 'air_description'=>'foo1','air_pop_mod'=>'foo2' };
    ConditionGenerator::set_air($condition);
    is($condition->{'seed'},40);
    is($condition->{'air_description'},'foo1');
    is($condition->{'air_pop_mod'},'foo2');

    done_testing();
};

1;

