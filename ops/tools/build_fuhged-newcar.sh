#!/usr/bin/env bash
# Pilot 3 "The New Car". Usage: build.sh <clip2 file> [video offset seconds per clip: o1 o2 o3]
set -euo pipefail
S=/tmp/claude-0/-home-claude/78ec04d5-29fd-5ca6-94f4-999a4ff9e093/scratchpad; P=$S/p3; B=$S/pilot1/build
FONTS=/home/claude/donnie-does-deals/brand/fonts
C2=${1:-c2.mp4}; O1=${2:-0}; O2=${3:-0}; O3=${4:-0}
NV="fps=30,setsar=1,format=yuv420p,settb=AVTB"; NA="aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo,asettb=AVTB"
# Punch-in crop (static, no animated zoom) so the face reads bigger: 1.2x, biased to upper frame.
PUNCH="scale=1296:-2:flags=lanczos,crop=1080:1920:108:180"
cd $P
v(){ python3 -c "print(round(0.3+float('$1'),3))"; }
ffmpeg -loglevel error -y -i c1.mp4 -i $C2 -i c3.mp4 -i tw.wav -loop 1 -i hook.png -i $S/pilot1/bed_swagger.wav -filter_complex "
 [0:v]$PUNCH,$NV,trim=$(v $O1):$(python3 -c "print(round(0.3+float('$O1')+4.14,3))"),setpts=PTS-STARTPTS[v1];
 [1:v]scale=1458:-2:flags=lanczos,crop=1080:1920:189:260,$NV,trim=$(v $O2):$(python3 -c "print(round(0.3+float('$O2')+4.21,3))"),setpts=PTS-STARTPTS[v2];
 [2:v]$PUNCH,$NV,trim=$(v $O3):$(python3 -c "print(round(0.3+float('$O3')+2.01,3))"),setpts=PTS-STARTPTS[v3];
 [3:a]$NA,atrim=0.12:10.48,asetpts=PTS-STARTPTS[vo];
 [v1][v2][v3]concat=n=3:v=1:a=0[cv];
 [4:v]format=rgba,trim=0:2.6,fade=t=out:st=2.3:d=0.3:alpha=1,setpts=PTS-STARTPTS[hk];
 [cv][hk]overlay=0:0:eof_action=pass:enable='lte(t,2.6)',ass=subs.ass:fontsdir=$FONTS,$NV[vout];
 [5:a]$NA,atrim=0:10.36,asetpts=PTS-STARTPTS,volume=0.11,afade=t=in:d=0.4,afade=t=out:st=10.06:d=0.3[bed];
 [vo][bed]amix=inputs=2:normalize=0:duration=first,loudnorm=I=-16:TP=-1.5:LRA=11,$NA,atrim=0:10.36[aout]" \
 -map "[vout]" -map "[aout]" -t 10.36 -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k body.mp4
ffmpeg -loglevel error -y -i body.mp4 -i $B/endcard.mp4 -filter_complex "[0:v]$NV[v0];[1:v]$NV[v1];[0:a]$NA[a0];[1:a]$NA[a1];[v0][a0][v1][a1]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart fuhged-newcar_v1.mp4
echo built
