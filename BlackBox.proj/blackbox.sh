#!/bin/bash

## BlackBox V1.0.4-2 BPFW Revision 3
## Developed & Maintained By The BlackBox Computer Security Research And Development Team
## (C) 2023 Onetrak Digital Forensics Corporation
## Licensed (GNU) Revision 3



arg1="$1"
arg2="$2"
specialarg="$3"
installcanidate="$4"
localscript="$PWD"

dir_setup () {

    local_bash="$localscript/bin/bash_ext"
    local_scriptext="$localscript/ext"
    localrepo="$localscript/repo"

    if [ ! -d "$local_scriptext" ]; then

        mkdir -p "$local_scriptext"

    fi

}

dir_setup

mainprog () {

    function_dictionary () {

        func.loadlocal () {

            if [ -d "$localscript/bin/bash_ext" ]; then

                if [ -f "$local_bash/ansi/ansi" ]; then

                    . "$local_bash/ansi/ansi"

                    tout_red="ansi --bold --red-intense"
                    tout_green="ansi --bold --green-intense"
                    tout_yellow="ansi --bold --yellow-intense"

                fi

                if [ -f "$local_bash/bash-ini-parser/bash-ini-parser" ]; then

                    . "$local_bash/bash-ini-parser/bash-ini-parser"

                    if [ -f "$localscript/bin/bb_conf.ini" ]; then

                        cfg_parser "$localscript/bin/bb_conf.ini"
                        cfg_section_prog_conf
                        cfg_section_script_info

                    fi

                fi

            else

                echo ""
                echo " [ ERROR ] Could Not Find Local Script Area"
                echo ""

                exit

            fi

            bpfw.listfunc () {

                funclst=$( declare -F | awk '{print $NF}' | sort | egrep -v "^_" )
                $tout_red "$(echo "$funclst" | grep func.)"

            }

            bpfw.proghelp () {

                echo ""
                $tout_red "$(cat $localscript/bin/usage.txt)"
                echo ""

            }

            bpfw.upgrade_client () {


                func.upgrade () {

                    clear

                    cd "$localscript"
                    cd ..
                    cd ..

                    if [ -d "BlackBox" ]; then

                        rm -r "BlackBox"

                    else

                        $tout_yellow " [ ERROR ] Project Has Left GitHub Repository Area! Update Will Now Exit!"

                        exit

                    fi

                    git clone $repo_url

                    cd $localscript

                    clear

                    $tout_green " [ BPFW.UPGRADE_CLIENT ] Update Complete!"

                    exit
                    
                }

                client_old="$currentversion"
                cnf_url="https://raw.githubusercontent.com/odf-community/BlackBox/version.ini"
                repo_url="https://github.com/odf-community/BlackBox.git"

                echo ""
                $tout_red " [ BPFW.UPGRADE_CLIENT ] Check For Newer Version! Requires CURL"
                echo ""

                curl -s $cnf_url -o "/tmp/BBDigital_TMP/newversion.ini"

                if [ "$(cat "/tmp/BBDigital_TMP/newversion.ini" | grep 400)" == "400: Invalid request" ]; then

                    echo ""
                    $tout_yellow " [ ERROR ] Could Not Capture New Version Info!"
                    echo ""

                    exit

                else

                    echo ""
                    $tout_yellow " [ ERROR ] Could Not Capture New Version Info!"
                    echo ""

                    exit

                fi

                if [ "$client_old" == "$newversion" ]; then

                    $tout_green " [ BPFW.UPGRADE_CLIENT ] No New Updates Detected!, Exiting Update Script!"

                    update="false"

                    exit

                else

                    $tout_yellow " [ BPFW.UPGRADE_CLIENT ] Update $newversion Found!"
                    $tout_yellow "                         Old Client: $client_old"
                    $tout_yellow "                         New Client: $newversion"
                    echo ""
                    $tout_yellow " [ BPFW.UPGRADE_CLIENT ] https://github.com/odf-community/BlackBox/blob/main/UPDATES.md"

                    update="true"

                fi

                if [ "$update" == "true" ]; then

                    echo ""
                    $tout_yellow " [ BPWF.UPGRADE_CLIENT ] In Order To Process The Following Update Properly"
                    $tout_yellow "                         A Reinitialization Of The Current Script Area Must Occur"
                    $tout_yellow "                         This Will Wipe The Current 'database-remote' Area And Will"
                    $tout_yellow "                         Require You To Re-Import The Available Repositories."
                    echo ""

                    $tout_red -n " [ BPFW.UPGRADE_CLIENT ] Upgrade Client? [y/n?] "

                    read -r updateaskyn

                    if [ "$updateaskyn" == "y" ]; then

                        func.upgrade

                    elif [ "$updateaskyn" == "Y" ]; then

                        func.upgrade

                    else

                        $tout_yellow " [ BPFW.UPGRADE_CLIENT ] Exiting On Users Request"

                        exit

                    fi

                fi

            }

            bpfw.debugfw () {

                filesupplicant="$1"
                greplocale="$2"

                if [ -z "$filesupplicant" ]; then

                    echo ""
                    $tout_red " Missing Debug File Supplicant!"
                    echo ""

                    exit

                elif [[ -f "$filesupplicant" && ! -z "$greplocale" ]]; then

                    echo ""
                    $tout_green "Searching For String {$greplocale} in {$filesupplicant}"
                    echo ""

                    $tout_red "$(grep "$greplocale" "$filesupplicant")"

                else

                    echo ""
                    $tout_yellow " [ BPFW ERROR ] Missing {filesupplicant} or {greplocale}"
                    echo ""

                    exit

                fi
            }

        }

        func.show_banner () {

            echo ""
            $tout_red "$(cat "$localscript/bin/banner.ascii")"
            echo ""

        }

        func.show_version () {

            func.show_banner

            $tout_red -n "  Program Type: $progtype"
            $tout_red -n "  Program Version: $currentversion"
            $tout_red -n "  Program Branch: $currentbranch"
            $tout_red -n "  Script ID: ."$scriptid""
            $tout_red -n "  Script Control: $hostfunc"
            echo ""

        }

        func.nanoedit () {

            touchfile="$1"

            nano --nonewlines --linenumbers --softwrap "$touchfile"

            touch $touchfile

        }


        ## DATABASE MANAGER ##

        func.createdatabase () {

            if [ -z "$specialarg" ]; then

                echo ""
                $tout_yellow " [ ERROR ] Missing Repository Name Defined In {specialarg}"
                echo ""

                exit

            fi

            if [ ! -d "$localrepo" ]; then

                echo ""
                $tout_yellow " [ WARNING ] LocalRepo Area Does Not Exist!"
                $tout_green " [ WARNING ] Generating Local Repo Area!"

                mkdir -p "$localrepo"

            fi

            if [ ! -z "$specialarg" ]; then

                echo ""
                $tout_green " Generating New Local Repository {$specialarg}!"

                func.gen_localrepository () {

                    reponame="$specialarg"
                    repodir="$localrepo/$specialarg"

                    if [ -d "$localrepo" ]; then

                        mkdir -p "$repodir"

                        echo "## HTTPS AGENT ##" > $repodir/dl.info
                        echo "" >> $repodir/dl.info
                        echo "" >> $repodir/dl.info
                        echo "repo_url="'""'"" >> $repodir/dl.info
                        echo "pkgid="'""'"" >> $repodir/dl.info
                        echo "" >> $repodir/dl.info
                        echo "mkdir -p /tmp/BBDigital_TMP" >> $repodir/dl.info
                        echo "wget -P /tmp/BBDigital_TMP "'"$repo_url"'"/"'"$pkgid"'"" >> $repodir/dl.info
                        echo "" >> $repodir/dl.info
                        echo "## Remove "'""'" In {repo_url} & {pkgid} And Input Remote Database Package Location ##" >> $repodir/dl.info

                    fi

                    if [ "$installcanidate" == "localdb" ]; then

                        echo ""
                        $tout_yellow " {installcanidate} using approved 'localdb' Scheme!"
                        $tout_yellow " {installcanidate} REPORTS: Requires 3-rd Party Database Publish Supplicant!"
                        echo ""

                        mkdir -p "$localrepo/$specialarg/database-remote"
                        mkdir -p "$localrepo/$specialarg/database-remote/db_data.pkg"

                        $tout_yellow " {installcanidate} REPORTS: Generating '/dbinit.ini' File"
                        echo ""

                        echo "[db_info]" > "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "db_name=$specialarg-pkglst" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "[db_struct]" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "db_local=repo/$specialarg/database-remote" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "db_init=dbinit.ini" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "db_listing=listing.dbindex" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "[db_sizedata]" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "db_files=0" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "db_folders=0" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "db_size_mb=0.000" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "[db_dependabot]" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "dep_debian="'"NA"'"" >> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "dep_fedora="'"NA"'"">> "$localrepo/$specialarg/database-remote/dbinit.ini"
                        echo "dep_mac="'"NA"'"" >> "$localrepo/$specialarg/database-remote/dbinit.ini"

                        $tout_yellow " {installcanidate} REPORTS: Generating '/bd_data.pkg/listing.dbindex' File"
                        echo ""

                        echo "## $specialarg Repository Listing ##" > "$localrepo/$specialarg/database-remote/db_data.pkg/listing.dbindex"

                        $tout_green " {installcanidate} REPORTS: Directory Scheme Generation Complete!"
                        echo ""

                        exit

                    fi

                }

                func.gen_localrepository

            fi

        }

        func.deletedatabase () {

            if [ -z "$specialarg" ]; then

                echo ""
                $tout_yellow " [ ERROR ] Missing Repository Name Defined In {specialarg}"
                echo ""

                exit

            fi

            if [ ! -d "$localrepo" ]; then

                echo ""
                $tout_yellow " [ WARNING ] LocalRepo Area Does Not Exist!"
                $tout_green " [ WARNING ] Generating Local Repo Area!"

                mkdir -p "$localrepo"

                echo ""
                $tout_yellow " [ ERROR ] Conflicting Argument Terminology. Cannot Delete Non-Existent Repo!"

                exit

            fi

            if [ ! -z "$specialarg" ]; then

                if [ -d "$localrepo/$specialarg" ]; then

                    if [ -z "$installcanidate" ]; then

                        echo ""
                        $tout_yellow " [ WARNING ] Are You Sure You Want To Delete The Following Repository!"
                        $tout_yellow " [ WARNING ] {$specialarg}"
                        echo ""
                        echo ""

                        $tout_red -n " [ ANSWER ] y/n? "

                        read -r deletewarn

                    elif [ "$installcanidate" == "remote" ]; then

                        echo ""
                        $tout_yellow " [ WARNING ] Are You Sure You Want To Delete The Following Remote Database!"
                        $tout_yellow " [ WARNING ] {$specialarg/database-remote}"
                        echo ""
                        echo ""

                        $tout_red -n " [ ANSWER ] y/n? "

                        read -r deletewarn

                    fi

                    if [ "$deletewarn" == "y" ]; then

                        if [ "$installcanidate" == "remote" ]; then

                            if [ -d "$localrepo/$specialarg/database-remote" ]; then

                                rm -r "$localrepo/$specialarg/database-remote"

                            else

                                echo ""
                                $tout_yellow " [ DM_MAN ] No Database To Delete!"
                                echo ""

                                exit 

                            fi
                            
                            specialarg="$specialarg/database-remote"

                        else

                            rm -r "$localrepo/$specialarg"

                        fi

                        echo ""
                        $tout_green " [ WARNING ] Resource {$specialarg} Has Been Removed Successfully!"

                        exit

                    else

                        echo ""
                        $tout_red " [ WARNING ] Exiting At Users Request!"

                        exit

                    fi

                fi

            fi

        }

        func.importdatabase () {

            if [ -z "$specialarg" ]; then

                echo ""
                $tout_yellow " [ ERROR ] Missing Repository Name Defined In {specialarg}"
                echo ""

                exit

            fi

            if [ -f "$localrepo/$specialarg/dl.info" ]; then

                echo ""
                $tout_green " [ DB_MAN ] Import Database @ repo/$specialarg/dl.info"; read -t .5
                echo ""
                $tout_yellow " [ DB_MAN ] Import Initiated!"; read -t .5
                echo ""

                if [ -f "/tmp/BBDigital_TMP/db_data.zip" ]; then

                    rm -r /tmp/BBDigital_TMP

                fi

                    . $localrepo/$specialarg/dl.info

                if [ ! -f "/tmp/BBDigital_TMP/db_data.zip" ]; then

                    echo ""
                    $tout_red " [ FATAL ERROR ] Database File Was Not Provided!"
                    echo ""

                    exit

                fi

                if [ -d "$localrepo/$specialarg/database-remote" ]; then

                    $tout_yellow " [ DB_MAN ] Reconstructing Local Database..."; read -t .5
                    echo ""

                    rm -r $localrepo/$specialarg/database-remote; read -t .5
                    mkdir -p $localrepo/$specialarg/database-remote; read -t .5

                    $tout_yellow "$(unzip /tmp/BBDigital_TMP/db_data.zip -d "$localrepo/$specialarg")"; read -t .5

                else

                    $tout_yellow " [ DB_MAN ]Constructing Local Database..."; read -t .5
                    echo ""

                    mkdir -p $localrepo/$specialarg/database-remote; read -t .5

                    $tout_yellow "$(unzip /tmp/BBDigital_TMP/db_data.zip -d "$localrepo/$specialarg")"; read -t .5

                fi

                echo ""
                $tout_green " [ DB_MAN ] Database Import Complete For dl.info {$specialarg}!"
                echo ""

                sleep 5

                clear

                func.show_banner

                cfg_parser "$localrepo/$specialarg/database-remote/dbinit.ini"
                cfg_section_db_info
                cfg_section_db_struct
                cfg_section_db_sizedata
                cfg_section_db_dependabot

                $tout_red " [ DB_MAN ] Database Location: $db_local"
                $tout_red " [ DB_MAN ] Database INIT File: $db_init"
                $tout_red " [ DB_MAN ] Database Listings File: $db_listing"
                echo ""
                $tout_red " [ DB_MAN ] Database Name: $db_name"
                $tout_red " [ DB_MAN ] Database Files: $db_files"
                $tout_red " [ DB_MAN ] Database Folders: $db_folders"
                $tout_red " [ DB_MAN ] Database Size (MB): $db_size_mb"
                echo ""
                $tout_red " [ DB_MAN ] Database Install Dependencies (Debian): $dep_debian"
                $tout_red " [ DB_MAN ] Database Install Dependencies (Mac-OS): $dep_mac"
                $tout_red " [ DB_MAN ] Database Install Dependencies (Fedora): $dep_fedora"
                echo ""
                $tout_red " [ DB_MAN ] Database Listing Data:"

                func.extlist

            else

                echo ""
                $tout_yellow " [ ERROR ] The Repository '$specialarg' Does Not Have An Install Agent"
                echo ""
                
                exit

            fi

        }

        func.extinstall () {

            clear

            func.show_banner

            if [ -z "$installcanidate" ]; then

                echo ""
                $tout_yellow " [ ERROR ] Missing Install Canidate @ {installcanidate}"
                echo ""

                exit

            fi

            if [ -d "$localrepo/$specialarg" ]; then

                echo ""
                $tout_yellow " [ DB_MAN ] Finding Install Canidate For {$installcanidate}"
                echo ""

                if [ -d "$localrepo/$specialarg/database-remote/db_data.pkg/$installcanidate" ]; then

                    $tout_green " [ DB_MAN ] Install Canidate Found!"
                    echo ""

                    sleep 5

                    . "$localrepo/$specialarg/database-remote/db_data.pkg/$installcanidate/setup.bbdigital"

                else

                    $tout_red " [ FATAL ERROR ] Could Not Find Install Canidate For {$installcanidate}"
                    echo ""

                    exit

                fi

            else

                echo ""
                $tout_yellow " [ ERROR ] Repository @ '$specialarg' Does Not Exist!"
                echo ""

                exit

            fi

        }

        func.extlist () {

            if [ -z "$specialarg" ]; then

                echo ""
                $tout_yellow " [ ERROR ] Missing Repository Name Defined In {specialarg}"
                echo ""

                exit

            fi

            if [ -d "$localrepo/$specialarg/database-remote/db_data.pkg" ]; then

                cd "$localrepo/$specialarg/database-remote/db_data.pkg"

                cfg_parser "$localrepo/$specialarg/database-remote/dbinit.ini"
                cfg_section_db_info
                cfg_section_db_struct
                cfg_section_db_sizedata
                cfg_section_db_dependabot

                $tout_red "$(cat listing.dbindex)"

            fi

        }

        ## DATABASE MANAGER ##

        func.progcontrol () {

            controlarg1="$1"
            controlarg2="$2"
            controlarg3="$3"

            clear

            if [ -z "$controlarg1" ]; then

                func.show_banner

                echo ""
                $tout_red " Internal Script Arbitrary Function Execution Control Panel"
                echo ""
                $tout_red " Usage: $0 --progctrl 'internal_function_name' 'controlarg2' 'controlarg3'"
                echo ""
                $tout_red " Example - "
                echo ""
                $tout_red " Create Local Repo & Database: $0 func.createdatabase 'my_repo' localdb"
                $tout_red " Import Remote Database: $0 func.importdatabase 'my_repo'"
                echo ""
                $tout_yellow " {controlarg2} May also be represented as {specialarg}"
                $tout_yellow " {controlarg3} May also be represented as {installcanidate}"
                echo ""
                $tout_red " To View Available Functions;"
                $tout_red " Execute: $0 $arg1 bpfw.listfunc"
                echo ""
                $tout_red " To Debug The Framework;"
                $tout_red " Execute $0 $arg1 bpfw.debugfw 'supplicantfile' 'greplocale'"
                $tout_yellow " {greplocale} Should be represented with "'""'""
                $tout_yellow " {greplocale} Certain locales may be unavilable due to the bash command interpretation method."
                echo ""

                exit

            else

                echo ""
                $tout_red " Executed -> $scriptlogin $0 --progctrl $controlarg1 $controlarg2 $controlarg3"
                echo ""

                sleep 1

                $controlarg1 $controlarg2 $controlarg3

                exit

            fi

        }

    }

    parsearg () {

        if [ "$arg1" == "--version" ]; then

            func.show_version

        elif [ "$arg1" == "--help" ]; then

            func.show_version
            bpfw.proghelp

        elif [ "$arg1" == "--progctrl" ]; then

            func.progcontrol $arg2 $specialarg $installcanidate

        # Repo Commands

            elif [[ "$arg1" == "--repo" && "$arg2" == "import" ]]; then

                func.show_banner
                func.importdatabase

            elif [[ "$arg1" == "--repo" && "$arg2" == "install" ]]; then

                func.show_banner
                func.extinstall

            elif [[ "$arg1" == "--repo" && "$arg2" == "list" ]]; then

                func.show_banner
                func.extlist

            elif [[ "$arg1" == "--repo" && "$arg2" == "create" ]]; then

                func.show_banner
                func.createdatabase

            elif [[ "$arg1" == "--repo" && "$arg2" == "delete" ]]; then

                func.show_banner
                func.deletedatabase

        else

            echo ""
            $tout_yellow " [ ERROR ] $0 $arg1 $arg2 $specialarg Is An Invalid Command!"
            echo ""

        fi

    }

}

prog_control () {

    function_dictionary

    func.loadlocal

    parsearg

}

mainprog
prog_control

exit 999