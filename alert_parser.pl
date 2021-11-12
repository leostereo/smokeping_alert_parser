#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use WWW::Curl::Easy;
use Log::Log4perl qw(:easy);

Log::Log4perl->easy_init(
        {
        file  => ">> /var/log/syslog",
        level => $INFO,
        },

        {
        file  => "STDERR",
        level => $DEBUG,
        }
        );


my $dir = "/opt/smokeping/";
my $log_file = "/opt/smokeping/alert_smokeping.log";
my %alert_arr;
my %ip_arr;
my $alerts;
my $counter;
my $command;
my $message = 'REPORTE SMOKEPING PARA SMOKEPING ZONDAS %0A';
my $url;
my $curl;
my $retcode;
my $response_body;

	open  $alerts, $log_file or die "Could not open $log_file: $!";

	while( my $line = <$alerts>)  {
	    my @spl = split(' ', $line);
	    	if (($spl[18]ne'') && ($spl[8]ne'')){
	    		$ip_arr{$spl[18]} = 0;
	    		$alert_arr{$spl[8]} = 0;
		}
	}

	close $alerts;

	foreach my $alert (sort keys %alert_arr) {
		$counter = 0;
		#print "$alert\n";
		foreach my $ip_line (sort keys %ip_arr) {
			#print "$ip_line\n";
		open  $alerts, $log_file or die "Could not open $log_file: $!";
		$counter = 0;
			while( my $line = <$alerts>)  {
				if (($line =~ m/$ip_line/) && ($line) =~ m/$alert/){
					$counter++;
				}
			}
			if($counter gt 0){
				$message .= "$alert matched on $ip_line $counter times%0A";
			}	
		close $alerts;
		}
	}

$url = 'https://api.telegram.org/bot830790814:AAF9J6sL7EEc8XESmZX2EH6NMjjBMjVxv_4/sendMessage?chat_id=-555669702&text='.$message;
$curl = WWW::Curl::Easy->new;
$curl->setopt(CURLOPT_HEADER,1);
$curl->setopt(CURLOPT_URL, $url);
$curl->setopt(CURLOPT_WRITEDATA,\$response_body);
$retcode = $curl->perform;
#print $response_body;

if($response_body =~ /message is too long/){
	$url = 'https://api.telegram.org/bot830790814:AAF9J6sL7EEc8XESmZX2EH6NMjjBMjVxv_4/sendMessage?chat_id=-555669702&text='.'Demasiadas alertas en SMOKEPING ZONDAS, corriga el archivo de logs';
	$curl = WWW::Curl::Easy->new;
	$curl->setopt(CURLOPT_HEADER,1);
	$curl->setopt(CURLOPT_URL, $url);
	$retcode = $curl->perform;

}else{
	print "telegram ok";
}


#LETS DELETE ALERTS AFTER SENT TELEGRAM
open $alerts, '>', $log_file;
INFO("smokeping alert report created");
