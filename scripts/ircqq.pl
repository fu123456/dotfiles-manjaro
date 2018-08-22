#!/usr/bin/env perl
use Mojo::Webqq;
my $client = Mojo::Webqq->new();
$client->load("ShowMsg");
$client->load("IRCShell"); #加载IRCShell插件
$client->run();
