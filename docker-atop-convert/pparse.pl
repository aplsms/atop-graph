#!/usr/bin/perl
#
print "# DDL
CREATE DATABASE grafana

# DML
# CONTEXT-DATABASE: grafana
";

while (<>) {
    chomp;
    #         PRG sdp-isopsn-219 1493164801 2017/04/26 00:00:01 14010331 58649 (qemu-system-x86) S 110 122 58649 84 -2147483648 1479707914
    #         (qemu-system-x86_64 -enable-kvm -name instance-0000e4aa -S -machine pc-i440fx-trusty,accel=kvm,usb=off -cpu Haswell,+smap,+adx,+rdseed,+3dnowprefetch,+)
    #          1 7 77 0 110 122 110 122 110 122 0
    if ($_ =~ /^PRG (\S+) (\d+) \S+ \S+ (\d+) (\d+) \((\S+)\) (\S) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) \(.*?\) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+)/) {

        local $host=$1;
        local $timestamp=$2;
        local $window=$3;
        local $PID=$4;
        local $pname=$5;
        print "PRG,host=$host,PID=$PID,Pname=$pname ";
        my $state=$6;
        if ($state eq "S") {print "state=0,"} elsif ($state eq "R") {print "state=1,"} elsif ($state eq "D") {print "state=2,"} else {print "state=3,"};
        local $real_uid=$7;
        local $real_gid=$8;
        local $TGID=$9;
        local $threads=$10;
        local $exit_code=$11;
        local $start_time=$12;
        local $PPID=$13;
        local $Rthreads=$14;
        local $Sthreads=$15;
        local $Dthreads=$16;
        local $euid=$17;
        local $egid=$18;
        local $suid=$19;
        local $sgid=$20;
        local $fuid=$21;
        local $fgid=$22;
        local $etime=$23;

        print "real_uid=$real_uid,real_gid=$real_gid,TGID=$TGID,threads=$threads,exit_code=$exit_code,start_time=$start_time,PPID=$PPID,";
        print "Rthreads=$Rthreads,Sthreads=$Sthreads,Dthreads=$Dthreads,euid=$euid,egid=$egid,suid=$suid,sgid=$sgid,fuid=$fuid,fgid=$fgid,etime=$etime";
        print " $timestamp\n";

#PRC sdp-isopsn-219 1493164801 2017/04/26 00:00:01 14010331 58649 (qemu-system-x86) S 100 3565962080 2805726138 0 120 0 0 27 0
    }elsif ($_ =~ /^PRC (\S+) (\d+) \S+ \S+ (\d+) (\d+) \((\S+)\) (\S) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+).*/ ){
        local $host=$1;
        local $timestamp=$2;
        local $window=$3;
        local $PID=$4;
        local $pname=$5;
        print "PRC,host=$host,PID=$PID,Pname=$pname ";
        my $state=$6;
        if ($state eq "S") {print "state=0,"} elsif ($state eq "R") {print "state=1,"} elsif ($state eq "D") {print "state=2,"} else {print "state=3,"};
        local $totticks=$7;               printf ("totticks=%d,",          $totticks);
        local $userclockticks=$8/$window; printf ("userclockticks=%d,",    $userclockticks);
        local $sclockticks=$9/$window;    printf ("sclockticks=%d,",       $sclockticks);
        local $nice=$10;                  printf ("nice=%d,",              $nice);
        local $priority=$11;              printf ("priority=%d,",          $priority);
        local $rtpriority=$12;            printf ("rtpriority=%d,",        $rtpriority);
        local $schedulingpolicy=$13;      printf ("schedulingpolicy=%d,",  $schedulingpolicy);
        local $currentCPU=$14;            printf ("currentCPU=%d,",        $currentCPU);
        local $sleepavg=$15;              printf ("sleepavg=%d",           $sleepavg);
        printf (" %d\n",$timestamp);

#PRM sdp-isopsn-219 1493164801 2017/04/26 00:00:01 14010331 58649 (qemu-system-x86) S 4096 250970588 240807896 4802 250970588 240807896 50985271497 3024638
    }elsif ($_ =~ /^PRM (\S+) (\d+) \S+ \S+ (\d+) (\d+) \((\S+)\) (\S) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+)/ ){
        local $host=$1;
        local $timestamp=$2;
        local $window=$3;
        local $PID=$4;
        local $pname=$5;
        print "PRM,host=$host,PID=$PID,Pname=$pname ";
        my $state=$6;
        if ($state eq "S") {print "state=0,"} elsif ($state eq "R") {print "state=1,"} elsif ($state eq "D") {print "state=2,"} else {print "state=3,"};
        local $pagess=$7/1024;              printf ("pagess=%d,",        $pagess);
        local $vmemsz=$8/1024;              printf ("vmemsz=%d,",        $vmemsz);
        local $rmemsz=$9/1024;              printf ("rmemsz=%d,",        $rmemsz);
        local $smemsz=$10/1024;             printf ("smemsz=%d,",        $smemsz);
        local $vmemgrow=$11/(1024*$window); printf ("vmemgrow=%d,",      $vmemgrow);
        local $rmemgrow=$12/(1024*$window); printf ("rmemgrow=%d,",      $rmemgrow);
        local $minpagefaults=$13/$window;   printf ("minpagefaults=%d,", $minpagefaults);
        local $majpagefaults=$14/$window;   printf ("majpagefaults=%d",  $majpagefaults);
        print " $timestamp\n";


#PRD sdp-isopsn-219 1493164801 2017/04/26 00:00:01 14010331 58649 (qemu-system-x86) S n y 30145495417 30145495417 166915234357 166915234357 0
    }elsif ($_ =~ /^PRD (\S+) (\d+) \S+ \S+ (\d+) (\d+) \((\S+)\) (\S) (\S) (\S) (\d+) (\d+) (\d+) (\d+) (\d+).*/ ){
        local $host=$1;
        local $timestamp=$2;
        local $window=$3;
        local $PID=$4;
        local $pname=$5;
        print "PRD,host=$host,PID=$PID,Pname=$pname ";
        my $state=$6;
        if ($state eq "S") {print "state=0,"} elsif ($state eq "R") {print "state=1,"} elsif ($state eq "D") {print "state=2,"} else {print "state=3,"};
        my $keypatch=$7;
        my $stdiostat=$8;
        if ($keypatch eq 'y')  { print ("keypatch=1,") }  else { print ("keypatch=0,") }
        if ($stdiostat eq 'y') { print ("stdiostat=1,") } else { print ("stdiostat=0,") }
        local $reads=$9/$window;    printf ("reads=%d,",     $reads);
        local $sreads=$10/$window;  printf ("sreads=%d,",    $sreads);
        local $writes=$11/$window;  printf ("writes=%d,",    $writes);
        local $swrites=$12/$window; printf ("swrites=%d,",   $swrites);
        local $cwrites=$13/$window; printf ("cwrites=%d",    $cwrites);
        print " $timestamp\n";

#PRN sdp-isopsn-219 1493164801 2017/04/26 00:00:01 14010331 58649 (qemu-system-x86) S n 0 0 0 0 0 0 0 0 0 0
    }elsif ($_ =~ /^PRN (\S+) (\d+) \S+ \S+ (\d+) (\d+) \((\S+)\) (\S) (\S) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+).*/ ){
        local $host=$1;
        local $timestamp=$2;
        local $window=$3;
        local $PID=$4;
        local $pname=$5;
        print "PRN,host=$host,PID=$PID,Pname=$pname ";
        my $state=$6;
        if ($state eq "S") {print "state=0,"} elsif ($state eq "R") {print "state=1,"} elsif ($state eq "D") {print "state=2,"} else {print "state=3,"};
        my $keypatch=$7;
        if ($keypatch eq 'y')  {print ("keypatch=1,") }  else { print ("keypatch=0,") }
        local $sendTCPpkt=$8/$window;   printf ("sendTCPpkt=%d,",  $sendTCPpkt);
        local $sendTCPdata=$9/$window;  printf ("sendTCPdata=%d,", $sendTCPdata);
        local $recvTCPpkt=$10/$window;  printf ("recvTCPpkt=%d,",  $recvTCPpkt);
        local $recvTCPdata=$11/$window; printf ("recvTCPdata=%d,", $recvTCPdata);
        local $sendUDPpkt=$12/$window;  printf ("sendUDPpkt=%d,",  $sendUDPpkt);
        local $sendUDPdata=$13/$window; printf ("sendUDPdata=%d,", $sendUDPdata);
        local $recvUDPpkt=$14/$window;  printf ("recvUDPpkt=%d,",  $recvUDPpkt);
        local $recvUDPdata=$15/$window; printf ("recvUDPdata=%d,", $recvUDPdata);
        local $sendRAWpkt=$16/$window;  printf ("sendRAWpkt=%d,",  $sendRAWpkt);
        local $recvRAWpkt=$17/$window;  printf ("recvRAWpkt=%d",  $recvRAWpkt);
        print " $timestamp\n";
    }


}

