BEGIN {
    print "# DDL"
    print "CREATE DATABASE grafana"
    print ""
    print "# DML"
    print "# CONTEXT-DATABASE: grafana"

} # PARSEABLE OUTPUT     With the flag -P followed by a list of one or more

# labels (comma-separated), parseable output is produced for each sample.  The
# labels that can be specified for system-level statistics correspond to the
# labels (first verb of each line) that can be found in the interactive output:
# "CPU", "cpu" "CPL" "MEM", "SWP", "PAG", "LVM", "MDD", "DSK" and "NET". For
# process-level  statistics special labels are introduced: "PRG" (general),
# "PRC" (cpu), "PRM" (memory), "PRD" (disk, only if the kernel-patch has been
# installed) and "PRN" (network, only if the kernel-patch has been installed).
# With the label "ALL", all system- and process-level statistics are shown.

# For every interval all requested lines are shown whereafter atop shows a line
# just containing the label "SEP" as a separator before the lines for the next
# sample are generated. When a sample contains the values since boot, atop shows
# a line just containing the label "RESET" before the lines for this sample are
# generated.

# The first part of each output-line consists of the following six fields: label
# (the name of the label), host (the name of this machine), epoch (the time of
# this  interval  as  number  of  seconds  since 1-1-1970), date (date of this
# interval in format YYYY/MM/DD), time (time of this interval in format
# HH:MM:SS), and interval (number of seconds elapsed for this interval).

# The subsequent fields of each output-line depend on the label:

# CPU      Subsequent  fields: total number of clock-ticks per second for this
# machine, number of processors, consumption for all CPU's in system mode
# (clock-ticks), consumption for all CPU's in user mode         (clock-ticks),
# consumption for all CPU's in user mode for niced processes (clock-ticks),
# consumption for all CPU's in idle mode (clock-ticks), consumption for all
# CPU's  in  wait  mode  (clock-         ticks),  consumption for all CPU's in
# irq mode (clock-ticks), consumption for all CPU's in softirq mode (clock-
# ticks), consumption for all CPU's in steal mode (clock-ticks), and consumption
# for         all CPU's in guest mode (clock-ticks).

# cpu      Subsequent fields: total number of clock-ticks per second for this
# machine, processor-number, consumption for this CPU in system mode (clock-
# ticks),  consumption  for  this  CPU  in  user  mode         (clock-ticks),
# consumption for this CPU in user mode for niced processes (clock-ticks),
# consumption for this CPU in idle mode (clock-ticks), consumption for this CPU
# in wait mode (clock-ticks),         consumption for this CPU in irq mode
# (clock-ticks), consumption for this CPU in softirq mode (clock-ticks),
# consumption for this CPU in steal mode (clock-ticks), and consumption for this
# CPU in         guest mode (clock-ticks).

# CPL      Subsequent  fields:  number  of  processors,  load  average for last
# minute, load average for last five minutes, load average for last fifteen
# minutes, number of context-switches, and number of         device interrupts.

# MEM      Subsequent fields: page size for this machine (in bytes), size of
# physical memory (pages), size of free memory (pages), size of page cache
# (pages), size of buffer cache (pages),  size  of  slab         (pages), and
# number of dirty pages in cache.

# SWP      Subsequent  fields:  page  size  for  this  machine  (in  bytes),
# size of swap (pages), size of free swap (pages), 0 (future use), size of
# committed space (pages), and limit for committed space         (pages).

# PAG      Subsequent fields: page size for this machine (in bytes), number of
# page scans, number of allocstalls, 0 (future use), number of swapins, and
# number of swapouts.

# LVM/MDD/DSK         For every logical volume/multiple device/hard disk one
# line is shown.         Subsequent fields: name, number of milliseconds spent
# for I/O, number of reads issued, number of sectors transferred for reads,
# number of writes issued, and number of  sectors  transferred  for
# write.

# NET      First one line is produced for the upper layers of the TCP/IP stack.
# Subsequent  fields: the verb "upper", number of packets received by TCP,
# number of packets transmitted by TCP, number of packets received by UDP,
# number of packets transmitted by UDP, number of packets received by IP, number
# of packets transmitted by IP, number of packets delivered to higher layers by
# IP, and number of packets forwarded by IP.

# Next one line is shown for every interface. Subsequent fields: name of the
# interface, number of packets received by the interface, number of bytes
# received by the interface, number of packets transmitted by the interface,
# number of bytes transmitted by the interface, interface speed, and duplex mode
# (0=half, 1=full).


{
    MB=1000000
    KB=1000
    SEC=512
     if      ($1=="CPL") {
        #CPL node-148 1464037202 2016/05/23 14:00:02 980579 24 8.28 9.32 9.95 47833683506 22833347589
        printf "%s,host=%s", $1, $2
        printf (" cores=%d,1min=%.2f,5min=%.2f,15min=%.2f,cont_sw=%d,ints=%d",
                  $7,       $8,      $9,       $10,     $11/$6,    $12/$6)
        printf " %d\n", $3
    }
    else if ($1=="CPU") {
        # 1                                           6      7   8  9         10        1      2          3        4    5        6 7 8    9
        # CPU node-148 1464037202 2016/05/23 14:00:02 980579 100 24 167054722 525625085 340138 1577650406 13623493 4556 10512712 0 0 1398 5
        printf "%s,host=%s", $1, $2
        printf (" cores=%d,sys=%.2f,user=%.2f,usernice=%.2f,idle=%.2f,wait=%.2f,irq=%.2f,softirq=%.2f,steal=%.2f,guest=%.2f,avgf=%d,avgscal=%d",
                       $8, $9/$6, $10/$6, $11/$6,     $12/$6, $13/$6, $14/$6,$15/$6,    $16/$6,  $17/$6,  $18,    $19)
        printf " %d\n", $3
    }
    else if ($1=="cpu") {
        printf "%s,host=%s", $1, $2
        # cpu node-148 1464037202 2016/05/23 14:00:02 980579 100 1 167054722 525625085 340138 1577650406 13623493 4556 10512712 0 0 1398 5
        printf (",CPUid=%d sys=%.2f,user=%.2f,usernice=%.2f,idle=%.2f,wait=%.2f,irq=%.2f,softirq=%.2f,steal=%.2f,guest=%.2f,avgf=%d,avgscal=%d",
                 $8,      $9/$6, $10/$6, $11/$6,     $12/$6, $13/$6, $14/$6,$15/$6,    $16/$6,  $17/$6,  $18,    $19)
        printf " %d\n", $3

    }
    else if ($1=="MEM") {
        printf "%s,host=%s", $1, $2
        #MEM node-148 1464382801 2016/05/27 14:00:01 1326179 4096 16467019 608133 3002631 61357 412961 664
        printf (" physical=%d,free=%d,cache=%d,buffer=%d,slab=%d,dirty=%d",
                  $8*$7/MB,$9*$7/MB,$10*$7/MB,$11*$7/MB,$12*$7/MB,$13*$7/MB)
        printf " %d\n", $3
    }
    else if ($1=="SWP") {
        printf "%s,host=%s", $1, $2
        # SWP node-148 1464382801 2016/05/27 14:00:01 1326179 4096 8388607 8267691 0 15506567 16622116
        printf " swap=%d,free=%d,committedsz=%d,committedlim=%d",$8*$7/MB,$9*$7/MB,$11*$7/MB,$12*$7/MB
        printf " %d\n", $3
    }
    else if ($1=="PAG") {
        printf "%s,host=%s", $1, $2
        # PAG node-148 1464382801 2016/05/27 14:00:01 1326179 4096 212028789 0 0 55472 172554
        printf " scanspg=%d,stalls=%d,swapins=%d,swapouts=%d", $8/$6,$9/$6,$11/$6,$12/$6
        printf " %d\n", $3
    }
    else if ($1=="LVM" || $1=="MDD" || $1=="DSK") {
        printf "%s,host=%s,name=%s", $1, $2, $7
        #DSK node-148 1464728422 2016/05/31 14:00:22 20 sda 5604 62 496 4862 593792
        # DSK,host=node-148,name=sda IOms=280,readsps=3,readMBps=0,writesps=243,writeMBps=289 1464728422
        #DSK | sda | busy  29% | | read  3/s | write  243/s |   | KiB/r  4 | KiB/w   61 | | MBr/s   0.01 | MBw/s  14.50 |              | avq    43.30 | avio 1.14 ms |

        printf " IOms=%d,readsps=%d,readMBps=%.2f,writesps=%d,writeMBps=%.2f",$8/$6,$9/$6,$10*SEC/MB/$6,$11/$6,$12*SEC/MB/$6
        printf " %d\n", $3
    }
    else if ($1=="NET") {
        printf "%s,host=%s,name=%s", $1, $2, $7
        if ($7=="upper") {
            # NET node-148 1464382801 2016/05/27 14:00:01 1326179 upper 5859424895 7210019396 15587722 11024355 5944037738 5846754023 5877062411 62976183
            printf (" tcpi=%d,tcpo=%d,udpi=%d,udpo=%d,ipi=%d,ipo=%d,deliv=%d,forward=%d",
                      $8/$6,  $9/$6,  $10/$6, $11/$6, $12/$6,$13/$6,$14/$6,  $15/$6)
        }else{
            # NET node-148 1464382801 2016/05/27 14:00:01 1326179 br-ex-vrouter 2604584 200750146 79802331 4928053739 0 1
            printf (" pkips=%d,Mpsrec=%.2f,pkops=%s,Mpssnd=%.2f,BWi=%.2f,BWo=%.2f",
                      $8/$6,    $9/$6/MB, $10/$6, $11/$6/MB,$9*8/$6/MB, $11*8/$6/MB)
        }
        printf " %d\n", $3
    }
}

#  for i in `find . -type f -name atop\*` ; do atop -r $i -P ALL |grep -v '^PR' >$i.ST-1; done
#  awk -f parse.awk st2-*   >out
#  influx -import -path=out -precision=s -host 10.211.55.19
