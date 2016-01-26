#!/usr/bin/perl -w
use DBI;

$ip=$ARGV[0] || '--help';
$dbname=$ARGV[1] || 'template1';
$dbuser=$ARGV[2] || 'postgres';
$password=$ARGV[3] || 'password';

#Default to Unknown Status
$status=3;

if ($ip !~ /\d+/)
{
        print "Provide a IP or hostname of the box to check time on using postgresql SELECT NOW()\n";
        exit 3;
}
else
{
        #print "Server is $server\n";
        #Connect to Database
        $Con = "DBI:Pg:dbname=$dbname;host=$ip";
        $Dbh = DBI->connect($Con, $dbuser, $password, {RaiseError =>1}) || die "Unable to access Database $dbname on host $ip as user $dbuser.\nError returned was: ". $DBI::errstr;

        $sql_max="SHOW max_connections;";
        $sql_curr="SELECT COUNT(*) FROM pg_stat_activity;";
        $sth_max = $Dbh->prepare($sql_max);
        $sth_curr = $Dbh->prepare($sql_curr);
        $sth_max->execute();
        while (($mconn) = $sth_max->fetchrow()) {
                $max_conn=$mconn;
        }
        $sth_curr->execute();
        while (($conn) = $sth_curr->fetchrow()) {
                $curr_conn=$conn;
        }
        $avail_conn=$max_conn-$curr_conn;
        $avail_pct=$avail_conn/$max_conn*100;
        $used_pct=sprintf("%2.1f", $curr_conn/$max_conn*100);

#       print "Max: $max_conn, Curr $curr_conn, Avail:$avail_conn, Avail Pct:$avail_pct";

        if ($avail_pct < 5)# || $avail_conn < 5)
        {
                $status=2;
        }
        elsif ($avail_pct < 25)# || $avail_conn < 25)
        {
                $status=1;
        }
        else
        {
                $status=0;
        }
                $msg="$curr_conn of $max_conn Connections Used ($used_pct%)";
# 1 WARNING
# 2 CRITICAL
# 3 UNKNOWN

        print $msg;
        exit $status;
}

