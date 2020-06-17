#!/bin/zsh

## COVID-19 STATISTICS TOOL ##
# Original author: Matt C <https://github.com/whitehat007>
#
# DISCLAIMER: This tool is for educational purposes only,
# and should not be construed as, replace, or supercede
# professional medical advice, nor be used to make critical
# decisions regarding health and/or safety as the data
# shown by this tool may be inaccurate and/or outdated.
#
# This tool depends on external databases/websites, and
# will not work without a functioning internet connection.
#
# IMPORTANT NOTE: Methods for counting cases differ greatly
# between countries, and certain case categories may not
# accurately reflect the true count. For example, Country A
# might under-estimate death counts while overestimating
# the number of total cases.
#
# See README for more information.

VERSION="0.5.1"

# find jq and numfmt executables
alias jq=$(echo `which jq`)
if [[ $? -ne 0 ]] ; then
	# default for macOS
    alias jq="/opt/local/bin/jq"
fi
alias nf=$(echo `which numfmt`)
if [[ $? -ne 0 ]] ; then
	# default for macOS
    alias nf="/opt/local/libexec/gnubin/numfmt"
fi

# ensure jq, nf, and curl work/are present
jq --help > /dev/null
if [[ $? -ne 0 ]] ; then
    echo "'jq' not found! Make sure you have installed it via MacPorts, HomeBrew, or another package manager." &>2
    echo "Exiting..." &>2
    exit 1
fi
nf --help > /dev/null
if [[ $? -ne 0 ]] ; then
    echo "'numfmt' not found! Make sure you have installed it via MacPorts, HomeBrew, or another package manager." &>2
    echo "Exiting..." &>2
    exit 1
fi
curl --help > /dev/null
if [[ $? -ne 0 ]] ; then
    echo "'curl'' not found! Make sure you have installed it via MacPorts, HomeBrew, or another package manager." &>2
    echo "Exiting..." &>2
    exit 1
fi



## CONSTANTS ##
API='https://covid-tracker-us.herokuapp.com'
APICALL=`curl -s $API/v2/locations`
APILATEST=`curl -s $API/v2/latest`
# Padding used for text justification
PAD='                                 '
SEP='─────────────────────────────────'
# List of country codes
CCLIST='["AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ","BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ","BK","BL","BM","BN","BO","BP","BQ","BR","BS","BT","BU","BV","BW","BX","BY","BZ","CA","CB","CC","CD","CE","CF","CG","CH","CI","CJ","CK","CL","CM","CN","CO","CP","CQ","CR","CS","CT","CU","CV","CW","CX","CY","CZ","DA","DB","DC","DD","DE","DF","DG","DH","DI","DJ","DK","DL","DM","DN","DO","DP","DQ","DR","DS","DT","DU","DV","DW","DX","DY","DZ","EA","EB","EC","ED","EE","EF","EG","EH","EI","EJ","EK","EL","EM","EN","EO","EP","EQ","ER","ES","ET","EU","EV","EW","EX","EY","EZ","FA","FB","FC","FD","FE","FF","FG","FH","FI","FJ","FK","FL","FM","FN","FO","FP","FQ","FR","FS","FT","FU","FV","FW","FX","FY","FZ","GA","GB","GC","GD","GE","GF","GG","GH","GI","GJ","GK","GL","GM","GN","GO","GP","GQ","GR","GS","GT","GU","GV","GW","GX","GY","GZ","HA","HB","HC","HD","HE","HF","HG","HH","HI","HJ","HK","HL","HM","HN","HO","HP","HQ","HR","HS","HT","HU","HV","HW","HX","HY","HZ","IA","IB","IC","ID","IE","IF","IG","IH","II","IJ","IK","IL","IM","IN","IO","IP","IQ","IR","IS","IT","IU","IV","IW","IX","IY","IZ","JA","JB","JC","JD","JE","JF","JG","JH","JI","JJ","JK","JL","JM","JN","JO","JP","JQ","JR","JS","JT","JU","JV","JW","JX","JY","JZ","KA","KB","KC","KD","KE","KF","KG","KH","KI","KJ","KK","KL","KM","KN","KO","KP","KQ","KR","KS","KT","KU","KV","KW","KX","KY","KZ","LA","LB","LC","LD","LE","LF","LG","LH","LI","LJ","LK","LL","LM","LN","LO","LP","LQ","LR","LS","LT","LU","LV","LW","LX","LY","LZ","MA","MB","MC","MD","ME","MF","MG","MH","MI","MJ","MK","ML","MM","MN","MO","MP","MQ","MR","MS","MT","MU","MV","MW","MX","MY","MZ","NA","NB","NC","ND","NE","NF","NG","NH","NI","NJ","NK","NL","NM","NN","NO","NP","NQ","NR","NS","NT","NU","NV","NW","NX","NY","NZ","OA","OB","OC","OD","OE","OF","OG","OH","OI","OJ","OK","OL","OM","ON","OO","OP","OQ","OR","OS","OT","OU","OV","OW","OX","OY","OZ","PA","PB","PC","PD","PE","PF","PG","PH","PI","PJ","PK","PL","PM","PN","PO","PP","PQ","PR","PS","PT","PU","PV","PW","PX","PY","PZ","QA","QB","QC","QD","QE","QF","QG","QH","QI","QJ","QK","QL","QM","QN","QO","QP","QQ","QR","QS","QT","QU","QV","QW","QX","QY","QZ","RA","RB","RC","RD","RE","RF","RG","RH","RI","RJ","RK","RL","RM","RN","RO","RP","RQ","RR","RS","RT","RU","RV","RW","RX","RY","RZ","SA","SB","SC","SD","SE","SF","SG","SH","SI","SJ","SK","SL","SM","SN","SO","SP","SQ","SR","SS","ST","SU","SV","SW","SX","SY","SZ","TA","TB","TC","TD","TE","TF","TG","TH","TI","TJ","TK","TL","TM","TN","TO","TP","TQ","TR","TS","TT","TU","TV","TW","TX","TY","TZ","UA","UB","UC","UD","UE","UF","UG","UH","UI","UJ","UK","UL","UM","UN","UO","UP","UQ","UR","US","UT","UU","UV","UW","UX","UY","UZ","VA","VB","VC","VD","VE","VF","VG","VH","VI","VJ","VK","VL","VM","VN","VO","VP","VQ","VR","VS","VT","VU","VV","VW","VX","VY","VZ","WA","WB","WC","WD","WE","WF","WG","WH","WI","WJ","WK","WL","WM","WN","WO","WP","WQ","WR","WS","WT","WU","WV","WW","WX","WY","WZ","XA","XB","XC","XD","XE","XF","XG","XH","XI","XJ","XK","XL","XM","XN","XO","XP","XQ","XR","XS","XT","XU","XV","XW","XX","XY","XZ","YA","YB","YC","YD","YE","YF","YG","YH","YI","YJ","YK","YL","YM","YN","YO","YP","YQ","YR","YS","YT","YU","YV","YW","YX","YY","YZ","ZA","ZB","ZC","ZD","ZE","ZF","ZG","ZH","ZI","ZJ","ZK","ZL","ZM","ZN","ZO","ZP","ZQ","ZR","ZS","ZT","ZU","ZV","ZW","ZX","ZY","ZZ"]'
ALTFORM="* Alt. fatality formula used"

## GLOBAL VARS ##
C=0
D=0
R=0
export ALTDR=false

# Print usage and exit
function printUsage() {
    CMDNAME=`basename $ZSH_ARGZERO`
    echo "$CMDNAME [all | usa]"
    echo "$CMDNAME (--fatal | -f) XX [XX ...]"
    echo "$CMDNAME (--loc | -l) XX [XX ...]"
    echo "         where 'XX' is a valid ISO-3166-1 alpha-2 country code"
    echo "         Use '00' for global statistics" 
    echo "$CMDNAME (--help | -h)"
    echo "$CMDNAME (--version | -v)"
    exit 0
}

# Validate the country code passed as $1
function checkCountry() {
    if [[ $# -ne 1 ]] ; then
	echo "Argument required for function $0!" >&2
        exit 1
    fi
    CC=$1
    JSTR=`echo "contains(['$CC'])" | sed s/\'/\"/g`
    RESULT=`echo $CCLIST | jq $JSTR`
    if [[ $RESULT == "true" ]] ; then
        return 0
    else
        return 1
    fi
}

# Get the latest global statistics
function getAll() {
    LATEST=`echo $APILATEST`
    CD=`echo $LATEST | jq '.latest.confirmed'`
    CONFIRMED=`echo $CD | nf --g`
    CCOL=${PAD:0:((17-${#CONFIRMED}))}
    DD=`echo $LATEST | jq '.latest.deaths'`
    DEAD=`echo $DD | nf --g`
    DCOL=${PAD:0:((26-${#DEAD}))}
    RD=`echo $LATEST | jq '.latest.recovered'`
    RECOVERED=`echo $RD | nf --g`
    RCOL=${PAD:0:((23-${#RECOVERED}))}
    EQ="(($DD + 0.0) / ($DD + $RD + 0.0)) * 100.0"
    DR=${"$(($EQ))":0:4}
    if [[ $RD -eq 0 ]] && [[ $CD -ne 0 ]] ; then
		EQ="(($DD + 0.0) / ($CD + 0.0)) * 100.0"
		DR=${"$(($EQ))":0:4}
		DEATHRATE="$DR%*"
		ALTDR=true
    else
		DEATHRATE=$([[ $DR == "NaN" ]] && echo " N/A" || echo " $DR%")
		ALTDR=false
    fi
    DRCOL=${PAD:0:((19-${#DEATHRATE}))}
    LUSTRING=`date +%X`
    echo "──────── COVID-19 STATUS ────────"
    echo "Confirmed Cases:$CCOL$CONFIRMED"
    echo "Deaths:$DCOL$DEAD"
    echo "Recovered:$RCOL$RECOVERED"
    echo "Fatality Rate:$DRCOL$DEATHRATE"
    
    return 0
}

# Get the latest statistics for the country code passed as $1
function getCountry() {
    if [[ $# -ne 1 ]] ; then
		echo "Argument required for function $0!" >&2
		echo
        printUsage
        exit 1
    fi
    CC=$1

    # if country code is 00 (global), then call `getAll` and return
    if [[ $CC == "00" ]] ; then
		getAll
	return 0
    fi
    
    checkCountry $CC
    if [[ $? -ne 0 ]] ; then
        echo "\"$CC\" is not a valid country code!" >&2
        echo "See 'https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements' for a list of valid codes." >&2
        echo
        printUsage
        return 1
    fi

    LU=`echo $DATA | jq '."locations" | .[0].last_updated | .[0:19]+"Z" | fromdate'`
    LUSTRING=`date -r $(($LU - 3600)) "+%X"`

    # making a separate variable string because jq requires '' surrounding arguments, which doesn't allow for $var expansion
    CSTR=`echo ".'locations' | map(select(.'country_code' == '$CC')) | .[].latest.confirmed" | sed s/\'/\"/g`
    echo $DATA | jq $CSTR | while read line
    do
		((C+=$line))
    done
    CONFIRMED=`echo $C | nf --g`
    CCOL=${PAD:0:((17-${#CONFIRMED}))}

    DSTR=`echo ".'locations' | map(select(.'country_code' == '$CC')) | .[].latest.deaths" | sed s/\'/\"/g`
    echo $DATA | jq $DSTR | while read line
    do
		((D+=$line))
    done
    DEAD=`echo $D | nf --g`
    DCOL=${PAD:0:((26-${#DEAD}))}

    RSTR=`echo ".'locations' | map(select(.'country_code' == '$CC')) | .[].latest.recovered" | sed s/\'/\"/g`
    echo $DATA | jq $RSTR | while read line
    do
		((R+=$line))
    done
    RECOVERED=`echo $R | nf --g`
    RCOL=${PAD:0:((23-${#RECOVERED}))}

    EQ="(($D + 0.0) / ($D + $R + 0.0)) * 100.0"
    DR=${"$(($EQ))":0:4}
    if [[ $R -eq 0 ]] && [[ $C -ne 0 ]] ; then
        EQ="(($D + 0.0) / ($C + 0.0)) * 100.0"
        DR=${"$(($EQ))":0:4}
        DEATHRATE="$DR%*"
		ALTDR=true
    else
		DEATHRATE=$([[ $DR == "NaN" ]] && echo " N/A" || echo " $DR%")
    fi
    DRCOL=${PAD:0:((19-${#DEATHRATE}))}
    
    echo "───── COVID-19 STATUS: ($CC) ─────"
    echo "Confirmed Cases:$CCOL$CONFIRMED"
    echo "Deaths:$DCOL$DEAD"
    echo "Recovered:$RCOL$RECOVERED"
    echo "Fatality Rate:$DRCOL$DEATHRATE"
    
    C=0
    D=0
    R=0
    return 0
}

# Get global fatality rate
function getDeathRate() {
    LATEST=`echo $APILATEST`
    DD=`echo $LATEST | jq '.latest.deaths'`
    RD=`echo $LATEST | jq '.latest.recovered'`
    EQ="(($DD + 0.0) / ($DD + $RD + 0.0)) * 100.0"
    DR=${"$(($EQ))":0:4}
    DEATHRATE=$([[ $DR == "NaN" ]] && echo "N/A" || echo "$DR%")
	DRPAD=${PAD:0:((7-${#DEATHRATE}))}
    echo "Fatality Rate (Global):$DRPAD$DEATHRATE"
    return 0
}

# Get fatality rate for country passed as $1
function getDeathRateForCountry() {
    if [[ $# -ne 1 ]] ; then
		echo "Invalid args to $0: $@" >&2
		printUsage
		exit 1
    fi
    CC=$1

    if [[ $CC == "00" ]] ; then
		getDeathRate
		return $?
    fi
    
    checkCountry $CC
    if [[ $? -ne 0 ]] ; then
        echo "\"$CC\" is not a valid country code!" >&2
        echo "See 'https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements' for a list of valid codes." >&2
        echo
        printUsage
        return 1
    fi
    
    LU=`echo $DATA | jq '."locations" | .[0].last_updated | .[0:19]+"Z" | fromdate'`
    LUSTRING=`date -r $(($LU - 3600)) "+%X"`

    # making a separate variable string because jq requires '' surrounding arguments, which doesn't allow for $var expansion
    CSTR=`echo ".'locations' | map(select(.'country_code' == '$CC')) | .[].latest.confirmed" | sed s/\'/\"/g`
    echo $DATA | jq $CSTR | while read line
    do
        ((C+=$line))
    done
    
    DSTR=`echo ".'locations' | map(select(.'country_code' == '$CC')) | .[].latest.deaths" | sed s/\'/\"/g`
    echo $DATA | jq $DSTR | while read line
    do
        ((D+=$line))
    done

    RSTR=`echo ".'locations' | map(select(.'country_code' == '$CC')) | .[].latest.recovered" | sed s/\'/\"/g`
    echo $DATA | jq $RSTR | while read line
    do
        ((R+=$line))
    done

    EQ="(($D + 0.0) / ($D + $R + 0.0)) * 100.0"
    DR=${"$(($EQ))":0:4}
    if [[ $R -eq 0 ]] && [[ $C -ne 0 ]] ; then
        EQ="(($D + 0.0) / ($C + 0.0)) * 100.0"
        DR=${"$(($EQ))":0:4}
        DEATHRATE="$DR%*"
		ALTDR=true
    else
		DEATHRATE=$([[ $DR == "NaN" ]] && echo "N/A" || echo "$DR%")
    fi
	DRPAD=${PAD:0:((11-${#DEATHRATE}))}
    echo "Fatality Rate ($CC):$DRPAD$DEATHRATE"
    
    C=0
    D=0
    R=0
    return 0
}


## MAIN FUNCTION ##
if [[ -z "$1" ]] ; then
	getAll
    echo $SEP
    [[ $ALTDR -eq true ]] && echo $ALTFORM
    echo "Last updated: $LUSTRING"
else
    case "$1" in
	all )
	    getAll
	    echo $SEP
	    [[ $ALTDR == true ]] && echo $ALTFORM
	    echo "Last updated: $LUSTRING"
	    ;;
	usa )
	    export DATA=`echo $APICALL`
	    getCountry "US"
	    echo $SEP
	    [[ $ALTDR == true ]] && echo $ALTFORM
	    echo "Last updated: $LUSTRING"
	    ;;
	-f | --fatal ) # fatality rate
	    if [[ $# -eq 1 ]] ; then
			getDeathRate
			echo
			[[ $ALTDR == true ]] && echo $ALTFORM
			exit $?
	    elif [[ $# -eq 2 ]] ; then
			export DATA=`echo $APICALL`
			getDeathRateForCountry ${2:u} # use :u to make uppercase
			echo 
	    else
			shift
			export DATA=`echo $APICALL`
			for country in $@
			do
				getDeathRateForCountry ${country:u}
			done
			echo ${SEP:0:30}
	    fi
	    [[ $ALTDR == true ]] && echo $ALTFORM
	    echo "Last updated: $LUSTRING"
	    ;;
	-l | --loc ) # locations
	    if [[ $# -eq 2 ]] ; then
			export DATA=`echo $APICALL`
			getCountry $2
			echo $SEP
	    elif [[ $# -gt 2 ]] ; then
			shift
     		export DATA=`echo $APICALL`
			getCountry ${1:u} # so there isn't a space before the first entry
			shift
			for country in $@
			do
				echo
				getCountry ${country:u}
			done
			echo $SEP
	    else
			echo "Error: You must specify at least one country code after \"$1\"." >&2
			echo
			printUsage
			exit 1
	    fi
	    [[ $ALTDR == true ]] && echo $ALTFORM
	    echo "Last updated: $LUSTRING"
	    ;;
	-h | --help ) # usage instructions
	    printUsage
	    exit 0
	    ;;
	-v | --version ) # version number
	    echo "COVID-19 Statistics, version $VERSION"
	    exit 0
	    ;;
	* ) # unknown arguments
	    echo "Error: Invalid arguement(s): $@" >&2
	    echo
	    printUsage
	    exit 1
	    ;;
    esac
fi
exit 0

