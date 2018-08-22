#!/usr/bin/env perl
use Mojo::Weixin;
my $client = Mojo::Weixin->new();
$client->load("ShowMsg");
$client->load("IRCShell"); #加载IRCShell插件
$client->run();
