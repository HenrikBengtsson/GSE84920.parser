#! /usr/bin/env bash
### Split HiC Count Data File into Chromosome-Pair Files
###
### Usage:
###  ./split.sh [options] path/to/*.summary.txt.gz
###
### Options:
###  --help       Display this help
###  --version    Display the version
###  --dryrun     Don't run anything
###  --intraonly  Only process intra-chromosome pairs
###
### Examples:
###  ./split.sh --intraonly hicData/GSE35156_GSM862720_J1_mESC_HindIII_ori_HiC.nodup.hic.summary.txt.gz
###
### This outputs *.tsv.gz files:
###
###   1. GSE35156_GSM862720_J1_mESC_HindIII_ori_HiC.nodup.hic.summary_chr1_vs_chr1.tsv.gz
###   2. GSE35156_GSM862720_J1_mESC_HindIII_ori_HiC.nodup.hic.summary_chr2_vs_chr2.tsv.gz
### ...
###  25. GSE35156_GSM862720_J1_mESC_HindIII_ori_HiC.nodup.hic.summary_chrM_vs_chrM.tsv.gz
###
### to folder hicData/GSE35156_GSM862720/ with names 
###
### Details:
### All produced files are written to folder 'hicData/<gse_id>_<gsm_id>/'
### where <gse_id> and <gsm_id> are inferred from the basename of the
### input '*.summary.txt.gz' file.  This output folder is automatically
### created, if missing.
### The produced files are names '<name>,<chr_i>_vs_<chr_j>.tsv.gz' where
### <name> is the name of input '*.summary.txt.gz' file without the extension.
###
### Version: 0.1.1
### Copyright: Henrik Bengtsson (2017-2019)
### License: GPL (>= 3.0)
### Source: https://github.com/HenrikBengtsson/ramani

function _help() {
    local res=
    res=$(grep -E "^###([ ].*|)$" "$1" | cut -b 5-)
    printf "%s\\n" "${res[@]}"
}

function _version() {
    grep -E "^###[ ]+Version: " "$1" | sed -E 's/.*Version:[ ]+//g' | sed 's/ //g'
}

chrs=({1..19} X Y M)
rootpath=hicData
dryrun=false
intraonly=false
src=

action=help
while [[ $# -gt 0 ]]; do
    if [[ "$1" == --help ]]; then
        action=help
    elif [[ "$1" == --version ]]; then
        action=version
    elif [[ "$1" == --dryrun ]]; then
	dryrun=true
    elif [[ "$1" == --intraonly ]]; then
	intraonly=true
    else
        action=
        src=$1
    fi
    shift
done

if [[ "$action" == help ]]; then
    _help "${BASH_SOURCE[0]}"
    exit 0
elif [[ "$action" == version ]]; then
    _version "${BASH_SOURCE[0]}"
    exit 0
fi

[[ -z "$src" ]] && echo "ERROR: No *.summary.txt.gz file specified" && exit 1
[[ ! -f "$src" ]] && echo "ERROR: No such file: $src" && exit 1

echo "Source file: $src"

dataset=$(basename "$src")
gse=${dataset/_*/}
gsm=${dataset/${gse}_/}
gsm=${gsm/_*/}
outpath="$rootpath/${gse}_${gsm}"
echo "Destination: $outpath"
mkdir -p "$outpath"
basename=${dataset/.txt.gz/}

echo "Chromosomes: ${chrs[*]}"

for ii in "${!chrs[@]}"; do
    chr_ii="chr${chrs[$ii]}"
    for jj in "${!chrs[@]}"; do
	[[ "$jj" -lt "$ii" ]] && continue
	## Intra-chromosome counts only?
	$intraonly && [[ "$jj" -ne "$ii" ]] && continue
        chr_jj="chr${chrs[$jj]}"
	dest="$outpath/$basename,${chr_ii}_vs_${chr_jj}.tsv.gz"
	printf " * %s: " "$dest"
	[[ -f "$dest" ]] && echo "already done" && continue
	pattern="[[:space:]]${chr_ii}[[:space:]].*[[:space:]]${chr_jj}[[:space:]]"
	printf "..."
	$dryrun && echo "dryrun" && continue
	zgrep -E "$pattern" "$src" | gzip > "$dest.tmp"
	mv "$dest.tmp" "$dest"
	echo " done"
    done
done
