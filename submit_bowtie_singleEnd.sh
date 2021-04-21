#!/bin/bash
#SBATCH -c 8
#SBATCH -N 1
#SBATCH -J aln
#SBATCH -o slurm-%J.mapping.out
#SBATCH -e slurm-%J.mapping.err
#SBATCH --mem 20G
#SBATCH -t 10-0:0:0

# usage: read1, dummy, sampleName, assembly, [tempdir]
# Note: chromosomes hardcoded for Zebrafish genome.

set -e

assembly=$4
nCores=$SLURM_CPUS_PER_TASK
if [ -z $5 ]
	then
	mkdir -p /mnt/scratch/piotr/
	tmpDir=$(mktemp /mnt/scratch/piotr/mapping.XXXXXXXXXX --directory)
else
	tmpDir=$5
fi

# keep contigs, but not chrM
if [[ $assembly == danRer10 ]]
    then
    goodChrs="chr1 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr2 chr20 chr21 chr22 chr23 chr24 chr25 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chrUn_KN149679v1 chrUn_KN149680v1 chrUn_KN149681v1 chrUn_KN149682v1 chrUn_KN149683v1 chrUn_KN149684v1 chrUn_KN149685v1 chrUn_KN149686v1 chrUn_KN149687v1 chrUn_KN149688v1 chrUn_KN149689v1 chrUn_KN149690v1 chrUn_KN149691v1 chrUn_KN149692v1 chrUn_KN149693v1 chrUn_KN149694v1 chrUn_KN149695v1 chrUn_KN149696v1 chrUn_KN149697v1 chrUn_KN149698v1 chrUn_KN149699v1 chrUn_KN149700v1 chrUn_KN149701v1 chrUn_KN149702v1 chrUn_KN149703v1 chrUn_KN149704v1 chrUn_KN149705v1 chrUn_KN149706v1 chrUn_KN149707v1 chrUn_KN149708v1 chrUn_KN149709v1 chrUn_KN149710v1 chrUn_KN149711v1 chrUn_KN149712v1 chrUn_KN149713v1 chrUn_KN149714v1 chrUn_KN149715v1 chrUn_KN149716v1 chrUn_KN149717v1 chrUn_KN149718v1 chrUn_KN149719v1 chrUn_KN149720v1 chrUn_KN149721v1 chrUn_KN149722v1 chrUn_KN149723v1 chrUn_KN149724v1 chrUn_KN149725v1 chrUn_KN149726v1 chrUn_KN149727v1 chrUn_KN149728v1 chrUn_KN149729v1 chrUn_KN149730v1 chrUn_KN149731v1 chrUn_KN149732v1 chrUn_KN149733v1 chrUn_KN149734v1 chrUn_KN149735v1 chrUn_KN149736v1 chrUn_KN149737v1 chrUn_KN149738v1 chrUn_KN149739v1 chrUn_KN149740v1 chrUn_KN149741v1 chrUn_KN149742v1 chrUn_KN149743v1 chrUn_KN149744v1 chrUn_KN149745v1 chrUn_KN149746v1 chrUn_KN149747v1 chrUn_KN149748v1 chrUn_KN149749v1 chrUn_KN149750v1 chrUn_KN149751v1 chrUn_KN149752v1 chrUn_KN149753v1 chrUn_KN149754v1 chrUn_KN149755v1 chrUn_KN149756v1 chrUn_KN149757v1 chrUn_KN149758v1 chrUn_KN149759v1 chrUn_KN149760v1 chrUn_KN149761v1 chrUn_KN149762v1 chrUn_KN149763v1 chrUn_KN149764v1 chrUn_KN149765v1 chrUn_KN149766v1 chrUn_KN149767v1 chrUn_KN149768v1 chrUn_KN149769v1 chrUn_KN149770v1 chrUn_KN149771v1 chrUn_KN149772v1 chrUn_KN149773v1 chrUn_KN149774v1 chrUn_KN149775v1 chrUn_KN149776v1 chrUn_KN149777v1 chrUn_KN149778v1 chrUn_KN149779v1 chrUn_KN149780v1 chrUn_KN149781v1 chrUn_KN149782v1 chrUn_KN149783v1 chrUn_KN149784v1 chrUn_KN149785v1 chrUn_KN149786v1 chrUn_KN149787v1 chrUn_KN149788v1 chrUn_KN149789v1 chrUn_KN149790v1 chrUn_KN149791v1 chrUn_KN149792v1 chrUn_KN149793v1 chrUn_KN149794v1 chrUn_KN149795v1 chrUn_KN149796v1 chrUn_KN149797v1 chrUn_KN149798v1 chrUn_KN149799v1 chrUn_KN149800v1 chrUn_KN149801v1 chrUn_KN149802v1 chrUn_KN149803v1 chrUn_KN149804v1 chrUn_KN149805v1 chrUn_KN149806v1 chrUn_KN149807v1 chrUn_KN149808v1 chrUn_KN149809v1 chrUn_KN149810v1 chrUn_KN149811v1 chrUn_KN149812v1 chrUn_KN149813v1 chrUn_KN149814v1 chrUn_KN149815v1 chrUn_KN149816v1 chrUn_KN149817v1 chrUn_KN149818v1 chrUn_KN149819v1 chrUn_KN149820v1 chrUn_KN149821v1 chrUn_KN149822v1 chrUn_KN149823v1 chrUn_KN149824v1 chrUn_KN149825v1 chrUn_KN149826v1 chrUn_KN149827v1 chrUn_KN149828v1 chrUn_KN149829v1 chrUn_KN149830v1 chrUn_KN149831v1 chrUn_KN149832v1 chrUn_KN149833v1 chrUn_KN149834v1 chrUn_KN149835v1 chrUn_KN149836v1 chrUn_KN149837v1 chrUn_KN149838v1 chrUn_KN149839v1 chrUn_KN149840v1 chrUn_KN149841v1 chrUn_KN149842v1 chrUn_KN149843v1 chrUn_KN149844v1 chrUn_KN149845v1 chrUn_KN149846v1 chrUn_KN149847v1 chrUn_KN149848v1 chrUn_KN149849v1 chrUn_KN149850v1 chrUn_KN149851v1 chrUn_KN149852v1 chrUn_KN149853v1 chrUn_KN149854v1 chrUn_KN149855v1 chrUn_KN149856v1 chrUn_KN149857v1 chrUn_KN149858v1 chrUn_KN149859v1 chrUn_KN149860v1 chrUn_KN149861v1 chrUn_KN149862v1 chrUn_KN149863v1 chrUn_KN149864v1 chrUn_KN149865v1 chrUn_KN149866v1 chrUn_KN149867v1 chrUn_KN149868v1 chrUn_KN149869v1 chrUn_KN149870v1 chrUn_KN149871v1 chrUn_KN149872v1 chrUn_KN149873v1 chrUn_KN149874v1 chrUn_KN149875v1 chrUn_KN149876v1 chrUn_KN149877v1 chrUn_KN149878v1 chrUn_KN149879v1 chrUn_KN149880v1 chrUn_KN149881v1 chrUn_KN149882v1 chrUn_KN149883v1 chrUn_KN149884v1 chrUn_KN149885v1 chrUn_KN149886v1 chrUn_KN149887v1 chrUn_KN149888v1 chrUn_KN149889v1 chrUn_KN149890v1 chrUn_KN149891v1 chrUn_KN149892v1 chrUn_KN149893v1 chrUn_KN149894v1 chrUn_KN149895v1 chrUn_KN149896v1 chrUn_KN149897v1 chrUn_KN149898v1 chrUn_KN149899v1 chrUn_KN149900v1 chrUn_KN149901v1 chrUn_KN149902v1 chrUn_KN149903v1 chrUn_KN149904v1 chrUn_KN149905v1 chrUn_KN149906v1 chrUn_KN149907v1 chrUn_KN149908v1 chrUn_KN149909v1 chrUn_KN149910v1 chrUn_KN149911v1 chrUn_KN149912v1 chrUn_KN149913v1 chrUn_KN149914v1 chrUn_KN149915v1 chrUn_KN149916v1 chrUn_KN149917v1 chrUn_KN149918v1 chrUn_KN149919v1 chrUn_KN149920v1 chrUn_KN149921v1 chrUn_KN149922v1 chrUn_KN149923v1 chrUn_KN149924v1 chrUn_KN149925v1 chrUn_KN149926v1 chrUn_KN149927v1 chrUn_KN149928v1 chrUn_KN149929v1 chrUn_KN149930v1 chrUn_KN149931v1 chrUn_KN149932v1 chrUn_KN149933v1 chrUn_KN149934v1 chrUn_KN149935v1 chrUn_KN149936v1 chrUn_KN149937v1 chrUn_KN149938v1 chrUn_KN149939v1 chrUn_KN149940v1 chrUn_KN149941v1 chrUn_KN149942v1 chrUn_KN149943v1 chrUn_KN149944v1 chrUn_KN149945v1 chrUn_KN149946v1 chrUn_KN149947v1 chrUn_KN149948v1 chrUn_KN149949v1 chrUn_KN149950v1 chrUn_KN149951v1 chrUn_KN149952v1 chrUn_KN149953v1 chrUn_KN149954v1 chrUn_KN149955v1 chrUn_KN149956v1 chrUn_KN149957v1 chrUn_KN149958v1 chrUn_KN149959v1 chrUn_KN149960v1 chrUn_KN149961v1 chrUn_KN149962v1 chrUn_KN149963v1 chrUn_KN149964v1 chrUn_KN149965v1 chrUn_KN149966v1 chrUn_KN149967v1 chrUn_KN149968v1 chrUn_KN149969v1 chrUn_KN149970v1 chrUn_KN149971v1 chrUn_KN149972v1 chrUn_KN149973v1 chrUn_KN149974v1 chrUn_KN149975v1 chrUn_KN149976v1 chrUn_KN149977v1 chrUn_KN149978v1 chrUn_KN149979v1 chrUn_KN149980v1 chrUn_KN149981v1 chrUn_KN149982v1 chrUn_KN149983v1 chrUn_KN149984v1 chrUn_KN149985v1 chrUn_KN149986v1 chrUn_KN149987v1 chrUn_KN149988v1 chrUn_KN149989v1 chrUn_KN149990v1 chrUn_KN149991v1 chrUn_KN149992v1 chrUn_KN149993v1 chrUn_KN149994v1 chrUn_KN149995v1 chrUn_KN149996v1 chrUn_KN149997v1 chrUn_KN149998v1 chrUn_KN149999v1 chrUn_KN150000v1 chrUn_KN150001v1 chrUn_KN150002v1 chrUn_KN150003v1 chrUn_KN150004v1 chrUn_KN150005v1 chrUn_KN150006v1 chrUn_KN150007v1 chrUn_KN150008v1 chrUn_KN150009v1 chrUn_KN150010v1 chrUn_KN150011v1 chrUn_KN150012v1 chrUn_KN150013v1 chrUn_KN150014v1 chrUn_KN150015v1 chrUn_KN150016v1 chrUn_KN150017v1 chrUn_KN150018v1 chrUn_KN150019v1 chrUn_KN150020v1 chrUn_KN150021v1 chrUn_KN150022v1 chrUn_KN150023v1 chrUn_KN150024v1 chrUn_KN150025v1 chrUn_KN150026v1 chrUn_KN150027v1 chrUn_KN150028v1 chrUn_KN150029v1 chrUn_KN150030v1 chrUn_KN150031v1 chrUn_KN150032v1 chrUn_KN150033v1 chrUn_KN150034v1 chrUn_KN150035v1 chrUn_KN150036v1 chrUn_KN150037v1 chrUn_KN150038v1 chrUn_KN150039v1 chrUn_KN150040v1 chrUn_KN150041v1 chrUn_KN150042v1 chrUn_KN150043v1 chrUn_KN150044v1 chrUn_KN150045v1 chrUn_KN150046v1 chrUn_KN150047v1 chrUn_KN150048v1 chrUn_KN150049v1 chrUn_KN150050v1 chrUn_KN150051v1 chrUn_KN150052v1 chrUn_KN150053v1 chrUn_KN150054v1 chrUn_KN150055v1 chrUn_KN150056v1 chrUn_KN150057v1 chrUn_KN150058v1 chrUn_KN150059v1 chrUn_KN150060v1 chrUn_KN150061v1 chrUn_KN150062v1 chrUn_KN150063v1 chrUn_KN150064v1 chrUn_KN150065v1 chrUn_KN150066v1 chrUn_KN150067v1 chrUn_KN150068v1 chrUn_KN150069v1 chrUn_KN150070v1 chrUn_KN150071v1 chrUn_KN150072v1 chrUn_KN150073v1 chrUn_KN150074v1 chrUn_KN150075v1 chrUn_KN150076v1 chrUn_KN150077v1 chrUn_KN150078v1 chrUn_KN150079v1 chrUn_KN150080v1 chrUn_KN150081v1 chrUn_KN150082v1 chrUn_KN150083v1 chrUn_KN150084v1 chrUn_KN150085v1 chrUn_KN150086v1 chrUn_KN150087v1 chrUn_KN150088v1 chrUn_KN150089v1 chrUn_KN150090v1 chrUn_KN150091v1 chrUn_KN150092v1 chrUn_KN150093v1 chrUn_KN150094v1 chrUn_KN150095v1 chrUn_KN150096v1 chrUn_KN150097v1 chrUn_KN150098v1 chrUn_KN150099v1 chrUn_KN150100v1 chrUn_KN150101v1 chrUn_KN150102v1 chrUn_KN150103v1 chrUn_KN150104v1 chrUn_KN150105v1 chrUn_KN150106v1 chrUn_KN150107v1 chrUn_KN150108v1 chrUn_KN150109v1 chrUn_KN150110v1 chrUn_KN150111v1 chrUn_KN150112v1 chrUn_KN150113v1 chrUn_KN150114v1 chrUn_KN150115v1 chrUn_KN150116v1 chrUn_KN150117v1 chrUn_KN150118v1 chrUn_KN150119v1 chrUn_KN150120v1 chrUn_KN150121v1 chrUn_KN150122v1 chrUn_KN150123v1 chrUn_KN150124v1 chrUn_KN150125v1 chrUn_KN150126v1 chrUn_KN150127v1 chrUn_KN150128v1 chrUn_KN150129v1 chrUn_KN150130v1 chrUn_KN150131v1 chrUn_KN150132v1 chrUn_KN150133v1 chrUn_KN150134v1 chrUn_KN150135v1 chrUn_KN150136v1 chrUn_KN150137v1 chrUn_KN150138v1 chrUn_KN150139v1 chrUn_KN150140v1 chrUn_KN150141v1 chrUn_KN150142v1 chrUn_KN150143v1 chrUn_KN150144v1 chrUn_KN150145v1 chrUn_KN150146v1 chrUn_KN150147v1 chrUn_KN150148v1 chrUn_KN150149v1 chrUn_KN150150v1 chrUn_KN150151v1 chrUn_KN150152v1 chrUn_KN150153v1 chrUn_KN150154v1 chrUn_KN150155v1 chrUn_KN150156v1 chrUn_KN150157v1 chrUn_KN150158v1 chrUn_KN150159v1 chrUn_KN150160v1 chrUn_KN150161v1 chrUn_KN150162v1 chrUn_KN150163v1 chrUn_KN150164v1 chrUn_KN150165v1 chrUn_KN150166v1 chrUn_KN150167v1 chrUn_KN150168v1 chrUn_KN150169v1 chrUn_KN150170v1 chrUn_KN150171v1 chrUn_KN150172v1 chrUn_KN150173v1 chrUn_KN150174v1 chrUn_KN150175v1 chrUn_KN150176v1 chrUn_KN150177v1 chrUn_KN150178v1 chrUn_KN150179v1 chrUn_KN150180v1 chrUn_KN150181v1 chrUn_KN150182v1 chrUn_KN150183v1 chrUn_KN150184v1 chrUn_KN150185v1 chrUn_KN150186v1 chrUn_KN150187v1 chrUn_KN150188v1 chrUn_KN150189v1 chrUn_KN150190v1 chrUn_KN150191v1 chrUn_KN150192v1 chrUn_KN150193v1 chrUn_KN150194v1 chrUn_KN150195v1 chrUn_KN150196v1 chrUn_KN150197v1 chrUn_KN150198v1 chrUn_KN150199v1 chrUn_KN150200v1 chrUn_KN150201v1 chrUn_KN150202v1 chrUn_KN150203v1 chrUn_KN150204v1 chrUn_KN150205v1 chrUn_KN150206v1 chrUn_KN150207v1 chrUn_KN150208v1 chrUn_KN150209v1 chrUn_KN150210v1 chrUn_KN150211v1 chrUn_KN150212v1 chrUn_KN150213v1 chrUn_KN150214v1 chrUn_KN150215v1 chrUn_KN150216v1 chrUn_KN150217v1 chrUn_KN150218v1 chrUn_KN150219v1 chrUn_KN150220v1 chrUn_KN150221v1 chrUn_KN150222v1 chrUn_KN150223v1 chrUn_KN150224v1 chrUn_KN150225v1 chrUn_KN150226v1 chrUn_KN150227v1 chrUn_KN150228v1 chrUn_KN150229v1 chrUn_KN150230v1 chrUn_KN150231v1 chrUn_KN150232v1 chrUn_KN150233v1 chrUn_KN150234v1 chrUn_KN150235v1 chrUn_KN150236v1 chrUn_KN150237v1 chrUn_KN150238v1 chrUn_KN150239v1 chrUn_KN150240v1 chrUn_KN150241v1 chrUn_KN150242v1 chrUn_KN150243v1 chrUn_KN150244v1 chrUn_KN150245v1 chrUn_KN150246v1 chrUn_KN150247v1 chrUn_KN150248v1 chrUn_KN150249v1 chrUn_KN150250v1 chrUn_KN150251v1 chrUn_KN150252v1 chrUn_KN150253v1 chrUn_KN150254v1 chrUn_KN150255v1 chrUn_KN150256v1 chrUn_KN150257v1 chrUn_KN150258v1 chrUn_KN150259v1 chrUn_KN150260v1 chrUn_KN150261v1 chrUn_KN150262v1 chrUn_KN150263v1 chrUn_KN150264v1 chrUn_KN150265v1 chrUn_KN150266v1 chrUn_KN150267v1 chrUn_KN150268v1 chrUn_KN150269v1 chrUn_KN150270v1 chrUn_KN150271v1 chrUn_KN150272v1 chrUn_KN150273v1 chrUn_KN150274v1 chrUn_KN150275v1 chrUn_KN150276v1 chrUn_KN150277v1 chrUn_KN150278v1 chrUn_KN150279v1 chrUn_KN150280v1 chrUn_KN150281v1 chrUn_KN150282v1 chrUn_KN150283v1 chrUn_KN150284v1 chrUn_KN150285v1 chrUn_KN150286v1 chrUn_KN150287v1 chrUn_KN150288v1 chrUn_KN150289v1 chrUn_KN150290v1 chrUn_KN150291v1 chrUn_KN150292v1 chrUn_KN150293v1 chrUn_KN150294v1 chrUn_KN150295v1 chrUn_KN150296v1 chrUn_KN150297v1 chrUn_KN150298v1 chrUn_KN150299v1 chrUn_KN150300v1 chrUn_KN150301v1 chrUn_KN150302v1 chrUn_KN150303v1 chrUn_KN150304v1 chrUn_KN150305v1 chrUn_KN150306v1 chrUn_KN150307v1 chrUn_KN150308v1 chrUn_KN150309v1 chrUn_KN150310v1 chrUn_KN150311v1 chrUn_KN150312v1 chrUn_KN150313v1 chrUn_KN150314v1 chrUn_KN150315v1 chrUn_KN150316v1 chrUn_KN150317v1 chrUn_KN150318v1 chrUn_KN150319v1 chrUn_KN150320v1 chrUn_KN150321v1 chrUn_KN150322v1 chrUn_KN150323v1 chrUn_KN150324v1 chrUn_KN150325v1 chrUn_KN150326v1 chrUn_KN150327v1 chrUn_KN150328v1 chrUn_KN150329v1 chrUn_KN150330v1 chrUn_KN150331v1 chrUn_KN150332v1 chrUn_KN150333v1 chrUn_KN150334v1 chrUn_KN150335v1 chrUn_KN150336v1 chrUn_KN150337v1 chrUn_KN150338v1 chrUn_KN150339v1 chrUn_KN150340v1 chrUn_KN150341v1 chrUn_KN150342v1 chrUn_KN150343v1 chrUn_KN150344v1 chrUn_KN150345v1 chrUn_KN150346v1 chrUn_KN150347v1 chrUn_KN150348v1 chrUn_KN150349v1 chrUn_KN150350v1 chrUn_KN150351v1 chrUn_KN150352v1 chrUn_KN150353v1 chrUn_KN150354v1 chrUn_KN150355v1 chrUn_KN150356v1 chrUn_KN150357v1 chrUn_KN150358v1 chrUn_KN150359v1 chrUn_KN150360v1 chrUn_KN150361v1 chrUn_KN150362v1 chrUn_KN150363v1 chrUn_KN150364v1 chrUn_KN150365v1 chrUn_KN150366v1 chrUn_KN150367v1 chrUn_KN150368v1 chrUn_KN150369v1 chrUn_KN150370v1 chrUn_KN150371v1 chrUn_KN150372v1 chrUn_KN150373v1 chrUn_KN150374v1 chrUn_KN150375v1 chrUn_KN150376v1 chrUn_KN150377v1 chrUn_KN150378v1 chrUn_KN150379v1 chrUn_KN150380v1 chrUn_KN150381v1 chrUn_KN150382v1 chrUn_KN150383v1 chrUn_KN150384v1 chrUn_KN150385v1 chrUn_KN150386v1 chrUn_KN150387v1 chrUn_KN150388v1 chrUn_KN150389v1 chrUn_KN150390v1 chrUn_KN150391v1 chrUn_KN150392v1 chrUn_KN150393v1 chrUn_KN150394v1 chrUn_KN150395v1 chrUn_KN150396v1 chrUn_KN150397v1 chrUn_KN150398v1 chrUn_KN150399v1 chrUn_KN150400v1 chrUn_KN150401v1 chrUn_KN150402v1 chrUn_KN150403v1 chrUn_KN150404v1 chrUn_KN150405v1 chrUn_KN150406v1 chrUn_KN150407v1 chrUn_KN150408v1 chrUn_KN150409v1 chrUn_KN150410v1 chrUn_KN150411v1 chrUn_KN150412v1 chrUn_KN150413v1 chrUn_KN150414v1 chrUn_KN150415v1 chrUn_KN150416v1 chrUn_KN150417v1 chrUn_KN150418v1 chrUn_KN150419v1 chrUn_KN150420v1 chrUn_KN150421v1 chrUn_KN150422v1 chrUn_KN150423v1 chrUn_KN150424v1 chrUn_KN150425v1 chrUn_KN150426v1 chrUn_KN150427v1 chrUn_KN150428v1 chrUn_KN150429v1 chrUn_KN150430v1 chrUn_KN150431v1 chrUn_KN150432v1 chrUn_KN150433v1 chrUn_KN150434v1 chrUn_KN150435v1 chrUn_KN150436v1 chrUn_KN150437v1 chrUn_KN150438v1 chrUn_KN150439v1 chrUn_KN150440v1 chrUn_KN150441v1 chrUn_KN150442v1 chrUn_KN150443v1 chrUn_KN150444v1 chrUn_KN150445v1 chrUn_KN150446v1 chrUn_KN150447v1 chrUn_KN150448v1 chrUn_KN150449v1 chrUn_KN150450v1 chrUn_KN150451v1 chrUn_KN150452v1 chrUn_KN150453v1 chrUn_KN150454v1 chrUn_KN150455v1 chrUn_KN150456v1 chrUn_KN150457v1 chrUn_KN150458v1 chrUn_KN150459v1 chrUn_KN150460v1 chrUn_KN150461v1 chrUn_KN150462v1 chrUn_KN150463v1 chrUn_KN150464v1 chrUn_KN150465v1 chrUn_KN150466v1 chrUn_KN150467v1 chrUn_KN150468v1 chrUn_KN150469v1 chrUn_KN150470v1 chrUn_KN150471v1 chrUn_KN150472v1 chrUn_KN150473v1 chrUn_KN150474v1 chrUn_KN150475v1 chrUn_KN150476v1 chrUn_KN150477v1 chrUn_KN150478v1 chrUn_KN150479v1 chrUn_KN150480v1 chrUn_KN150481v1 chrUn_KN150482v1 chrUn_KN150483v1 chrUn_KN150484v1 chrUn_KN150485v1 chrUn_KN150486v1 chrUn_KN150487v1 chrUn_KN150488v1 chrUn_KN150489v1 chrUn_KN150490v1 chrUn_KN150491v1 chrUn_KN150492v1 chrUn_KN150493v1 chrUn_KN150494v1 chrUn_KN150495v1 chrUn_KN150496v1 chrUn_KN150497v1 chrUn_KN150498v1 chrUn_KN150499v1 chrUn_KN150500v1 chrUn_KN150501v1 chrUn_KN150502v1 chrUn_KN150503v1 chrUn_KN150504v1 chrUn_KN150505v1 chrUn_KN150506v1 chrUn_KN150507v1 chrUn_KN150508v1 chrUn_KN150509v1 chrUn_KN150510v1 chrUn_KN150511v1 chrUn_KN150512v1 chrUn_KN150513v1 chrUn_KN150514v1 chrUn_KN150515v1 chrUn_KN150516v1 chrUn_KN150517v1 chrUn_KN150518v1 chrUn_KN150519v1 chrUn_KN150520v1 chrUn_KN150521v1 chrUn_KN150522v1 chrUn_KN150523v1 chrUn_KN150524v1 chrUn_KN150525v1 chrUn_KN150526v1 chrUn_KN150527v1 chrUn_KN150528v1 chrUn_KN150529v1 chrUn_KN150530v1 chrUn_KN150531v1 chrUn_KN150532v1 chrUn_KN150533v1 chrUn_KN150534v1 chrUn_KN150535v1 chrUn_KN150536v1 chrUn_KN150537v1 chrUn_KN150538v1 chrUn_KN150539v1 chrUn_KN150540v1 chrUn_KN150541v1 chrUn_KN150542v1 chrUn_KN150543v1 chrUn_KN150544v1 chrUn_KN150545v1 chrUn_KN150546v1 chrUn_KN150547v1 chrUn_KN150548v1 chrUn_KN150549v1 chrUn_KN150550v1 chrUn_KN150551v1 chrUn_KN150552v1 chrUn_KN150553v1 chrUn_KN150554v1 chrUn_KN150555v1 chrUn_KN150556v1 chrUn_KN150557v1 chrUn_KN150558v1 chrUn_KN150559v1 chrUn_KN150560v1 chrUn_KN150561v1 chrUn_KN150562v1 chrUn_KN150563v1 chrUn_KN150564v1 chrUn_KN150565v1 chrUn_KN150566v1 chrUn_KN150567v1 chrUn_KN150568v1 chrUn_KN150569v1 chrUn_KN150570v1 chrUn_KN150571v1 chrUn_KN150572v1 chrUn_KN150573v1 chrUn_KN150574v1 chrUn_KN150575v1 chrUn_KN150576v1 chrUn_KN150577v1 chrUn_KN150578v1 chrUn_KN150579v1 chrUn_KN150580v1 chrUn_KN150581v1 chrUn_KN150582v1 chrUn_KN150583v1 chrUn_KN150584v1 chrUn_KN150585v1 chrUn_KN150586v1 chrUn_KN150587v1 chrUn_KN150588v1 chrUn_KN150589v1 chrUn_KN150590v1 chrUn_KN150591v1 chrUn_KN150592v1 chrUn_KN150593v1 chrUn_KN150594v1 chrUn_KN150595v1 chrUn_KN150596v1 chrUn_KN150597v1 chrUn_KN150598v1 chrUn_KN150599v1 chrUn_KN150600v1 chrUn_KN150601v1 chrUn_KN150602v1 chrUn_KN150603v1 chrUn_KN150604v1 chrUn_KN150605v1 chrUn_KN150606v1 chrUn_KN150607v1 chrUn_KN150608v1 chrUn_KN150609v1 chrUn_KN150610v1 chrUn_KN150611v1 chrUn_KN150612v1 chrUn_KN150613v1 chrUn_KN150614v1 chrUn_KN150615v1 chrUn_KN150616v1 chrUn_KN150617v1 chrUn_KN150618v1 chrUn_KN150619v1 chrUn_KN150620v1 chrUn_KN150621v1 chrUn_KN150622v1 chrUn_KN150623v1 chrUn_KN150624v1 chrUn_KN150625v1 chrUn_KN150626v1 chrUn_KN150627v1 chrUn_KN150628v1 chrUn_KN150629v1 chrUn_KN150630v1 chrUn_KN150631v1 chrUn_KN150632v1 chrUn_KN150633v1 chrUn_KN150634v1 chrUn_KN150635v1 chrUn_KN150636v1 chrUn_KN150637v1 chrUn_KN150638v1 chrUn_KN150639v1 chrUn_KN150640v1 chrUn_KN150641v1 chrUn_KN150642v1 chrUn_KN150643v1 chrUn_KN150644v1 chrUn_KN150645v1 chrUn_KN150646v1 chrUn_KN150647v1 chrUn_KN150648v1 chrUn_KN150649v1 chrUn_KN150650v1 chrUn_KN150651v1 chrUn_KN150652v1 chrUn_KN150653v1 chrUn_KN150654v1 chrUn_KN150655v1 chrUn_KN150656v1 chrUn_KN150657v1 chrUn_KN150658v1 chrUn_KN150659v1 chrUn_KN150660v1 chrUn_KN150661v1 chrUn_KN150662v1 chrUn_KN150663v1 chrUn_KN150664v1 chrUn_KN150665v1 chrUn_KN150666v1 chrUn_KN150667v1 chrUn_KN150668v1 chrUn_KN150669v1 chrUn_KN150670v1 chrUn_KN150671v1 chrUn_KN150672v1 chrUn_KN150673v1 chrUn_KN150674v1 chrUn_KN150675v1 chrUn_KN150676v1 chrUn_KN150677v1 chrUn_KN150678v1 chrUn_KN150679v1 chrUn_KN150680v1 chrUn_KN150681v1 chrUn_KN150682v1 chrUn_KN150683v1 chrUn_KN150684v1 chrUn_KN150685v1 chrUn_KN150686v1 chrUn_KN150687v1 chrUn_KN150688v1 chrUn_KN150689v1 chrUn_KN150690v1 chrUn_KN150691v1 chrUn_KN150692v1 chrUn_KN150693v1 chrUn_KN150694v1 chrUn_KN150695v1 chrUn_KN150696v1 chrUn_KN150697v1 chrUn_KN150698v1 chrUn_KN150699v1 chrUn_KN150700v1 chrUn_KN150701v1 chrUn_KN150702v1 chrUn_KN150703v1 chrUn_KN150704v1 chrUn_KN150705v1 chrUn_KN150706v1 chrUn_KN150707v1 chrUn_KN150708v1 chrUn_KN150709v1 chrUn_KN150710v1 chrUn_KN150711v1 chrUn_KN150712v1 chrUn_KN150713v1"
fi

# no chrM and contigs
if [[ $assembly == danRer7 ]]
   then
   goodChrs="chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chr23 chr24 chr25"
fi


echoerr() { cat <<< "$@" 1>&2; }

echoerr Using $tmpDir on `hostname`

echoerr Running: submit_bowtie_singleEnd.sh $1 $2 $3 $4

if [[ ! -s $3.$assembly.sorted.bam.bai ]]
then
	# run bowtie if bowtiestats do not exist or are zero (bowtied did not finish):
	if [ ! -e $3.$assembly.goodChr.sorted.bam.bai ]
	   then
	   echoerr Mapping $3 from $1 and $2
           bowtie2 --phred33-quals --threads $nCores -x /mnt/biggles/data/alignment_references/bowtie2/$assembly \
           --met-file $3.$assembly.bowtieStats --no-unal \
           -U $1 -S $tmpDir/$3.$assembly.sam 2> $3.$assembly.bowtieReport
	fi
	
	if [ ! -e $tmpDir/$3.$assembly.sorted.bam.bai ]
	   then
	   echoerr converting to bam...
	   samtools view -@ $nCores -q 10 -@ $nCores -b -u -o $tmpDir/$3.$assembly.bam $tmpDir/$3.$assembly.sam
	   echoerr sorting bam...
	   samtools sort -@ $nCores -T $tmpDir/$3.$assembly.tmp -o $tmpDir/$3.$assembly.sorted.bam $tmpDir/$3.$assembly.bam
	   samtools index $tmpDir/$3.$assembly.sorted.bam
	fi
	
	if [ ! -e $3.$assembly.goodChr.sorted.bam.bai ]
	   then
	   rm --force $tmpDir/$3.$assembly.sam \
	              $tmpDir/$3.$assembly.bam \
	              $tmpDir/$3.$assembly.bam.bai 
	   echoerr removing chrM...
	   samtools view -@ $nCores -b -o $3.$assembly.goodChr.sorted.bam $tmpDir/$3.$assembly.sorted.bam $goodChrs
	   samtools index $3.$assembly.goodChr.sorted.bam
	fi
	
	#~ if [ ! -e $3.$assembly.goodChr.sorted.bam ]
	   #~ then
	   #~ echoerr sorting bam...
	   #~ samtools sort -l 9 -@ $nCores -T $tmpDir/$3.$assembly.tmp -o $3.$assembly.goodChr.sorted.bam $tmpDir/$3.$assembly.goodChr.bam
	   #~ echoerr indexing bam...
	   #~ samtools index $3.$assembly.goodChr.sorted.bam
	#~ fi
	
	# cleanup of tmpDir:
	if [[ -e $3.$assembly.goodChr.sorted.bam.bai ]]
	    then
	    echoerr removing temporary files...
	    rm --force $tmpDir/$3.$assembly.goodChr.bam \
	               $tmpDir/$3.$assembly.sorted.bam \
	               $tmpDir/$3.$assembly.sorted.bam.bai
	    rmdir $tmpDir
	fi
fi



if [[ ! -e $3.$assembly.granges.RDS && $assembly =~ danRer ]]
   then
   echoerr creating GRanges...
   sbatch --mem 100G -c 1 -J Granges.$3 ~piotr/bin/bamSe2GRanges.R \
       $3.$assembly.goodChr.sorted.bam \
       $3.$assembly.granges.RDS \
       $assembly
fi

