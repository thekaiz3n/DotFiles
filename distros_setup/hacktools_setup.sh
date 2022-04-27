#!/usr/bin/env bash

DEBUG_STD="&>/dev/null"
DEBUG_ERROR="2>/dev/null"

go env -w GO111MODULE=auto

go install github.com/tomnomnom/fff@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/tomnomnom/hacks/tojson@latest
go install github.com/sensepost/gowitness@latest
go install github.com/shenwei356/rush@latest
go install github.com/projectdiscovery/naabu/cmd/naabu@latest
go install github.com/hakluke/hakcheckurl@latest
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install github.com/root4loot/rescope@latest
go install github.com/tomnomnom/gron@latest
go install github.com/tomnomnom/hacks/html-tool@latest
go install github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install github.com/tomnomnom/gf@latest
go install github.com/tomnomnom/qsreplace@latest
go install github.com/OWASP/Amass/v3/...@latest
go install github.com/ffuf/ffuf@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/gwen001/github-subdomains@latest
go install github.com/dwisiswant0/cf-check@latest
go install github.com/tomnomnom/hacks/waybackurls@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install github.com/tomnomnom/anew@latest
go install github.com/projectdiscovery/notify/cmd/notify@latest
go install github.com/daehee/mildew/cmd/mildew@latest
go install github.com/m4dm0e/dirdar@latest
go install github.com/tomnomnom/unfurl@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/gwen001/github-endpoints@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/bp0lr/gauplus@latest
go install github.com/lc/subjs@latest
go install github.com/KathanP19/Gxss@latest
go install github.com/jaeles-project/gospider@latest
go get github.com/cgboal/sonarsearch/cmd/crobat
go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest
go install github.com/hahwul/dalfox/v2@latest
go install github.com/d3mondev/puredns/v2@latest
go install github.com/Josue87/resolveDomains@latest
go install github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest
go install github.com/Josue87/gotator@latest
go install github.com/tomnomnom/hacks/kxss@latest
go install github.com/003random/getJS@latest
go install github.com/deletescape/goop@latest
go install github.com/tomnomnom/meg@latest
go install github.com/takshal/freq@latest
go install github.com/j3ssie/sdlookup@latest
go install -v github.com/signedsecurity/sigurlfind3r/cmd/sigurlfind3r@latest
go install github.com/chromedp/chromedp@latest
go install github.com/ferreiraklet/airixss@latest
go install github.com/ferreiraklet/nilo@latest

declare -A repos
repos["gf"]="tomnomnom/gf"
repos["Gf-Patterns"]="1ndianl33t/Gf-Patterns"
repos["LinkFinder"]="dark-warlord14/LinkFinder"
repos["Interlace"]="codingo/Interlace"
repos["JSScanner"]="0x240x23elu/JSScanner"
repos["GitTools"]="internetwache/GitTools"
repos["SecretFinder"]="m4ll0k/SecretFinder"
repos["M4ll0k"]="m4ll0k/BBTz"
repos["Git-Dumper"]="arthaud/git-dumper"
repos["CORStest"]="RUB-NDS/CORStest"
repos["Knock"]="guelfoweb/knock"
repos["Photon"]="s0md3v/Photon"
repos["Sudomy"]="screetsec/Sudomy"
repos["DNSvalidator"]="vortexau/dnsvalidator"
repos["Massdns"]="blechschmidt/massdns"

dir="$HOME/Tools"

mkdir -p ~/.gf
mkdir -p ~/Tools/
mkdir -p ~/.config/notify/
mkdir -p ~/.config/amass/
mkdir -p ~/.config/nuclei/
mkdir -p ~/Lists/

pip3 install uro

eval wget -nc -O ~/.gf/potential.json https://raw.githubusercontent.com/devanshbatham/ParamSpider/master/gf_profiles/potential.json $DEBUG_STD

cd "$dir" || {
    echo "Failed to cd to $dir in ${FUNCNAME[0]} @ line ${LINENO}"
    exit 1
}

# Standard repos installation
repos_step=0
for repo in "${!repos[@]}"; do
    repos_step=$((repos_step + 1))
    eval git clone https://github.com/${repos[$repo]} $dir/$repo $DEBUG_STD
    eval cd $dir/$repo $DEBUG_STD
    eval git pull $DEBUG_STD
    exit_status=$?
    
    if [ -s "requirements.txt" ]; then
        eval $SUDO pip3 install -r requirements.txt $DEBUG_STD
    fi
    if [ -s "setup.py" ]; then
        eval $SUDO python3 setup.py install $DEBUG_STD
    fi
    if [ -s "Makefile" ]; then
        eval $SUDO make $DEBUG_STD
        eval $SUDO make install $DEBUG_STD
    fi
    if [ "gf" = "$repo" ]; then
        eval cp -r examples/*.json ~/.gf $DEBUG_ERROR
    elif [ "Gf-Patterns" = "$repo" ]; then
        eval mv *.json ~/.gf $DEBUG_ERROR
    fi
    cd "$dir" || {
        echo "Failed to cd to $dir in ${FUNCNAME[0]} @ line ${LINENO}"
        exit 1
    }
done
