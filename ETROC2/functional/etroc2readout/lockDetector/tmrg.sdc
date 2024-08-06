set sdc_version 1.3

set tmrgSucces 0
set tmrgFailed 0
proc constrainNet netName {
  global tmrgSucces
  global tmrgFailed
  # find nets matching netName pattern
  set nets [dc::get_net $netName]
  if {[llength $nets] != 0} {
    set_dont_touch $nets
    incr tmrgSucces
  } else {
    puts "\[TMRG\] Warning! Net(s) '$netName' not found"
    incr tmrgFailed
  }
}

constrainNet /ljCDRLockFilter_inst/instantLockA
constrainNet /ljCDRLockFilter_inst/instantLockB
constrainNet /ljCDRLockFilter_inst/instantLockC
constrainNet /ljCDRLockFilter_inst/instantLockVotedA
constrainNet /ljCDRLockFilter_inst/instantLockVotedB
constrainNet /ljCDRLockFilter_inst/instantLockVotedC
constrainNet /ljCDRLockFilter_inst/lfLockThrCounterRegA[*]
constrainNet /ljCDRLockFilter_inst/lfLockThrCounterRegB[*]
constrainNet /ljCDRLockFilter_inst/lfLockThrCounterRegC[*]
constrainNet /ljCDRLockFilter_inst/lfLockThrCounterRegVotedA[*]
constrainNet /ljCDRLockFilter_inst/lfLockThrCounterRegVotedB[*]
constrainNet /ljCDRLockFilter_inst/lfLockThrCounterRegVotedC[*]
constrainNet /ljCDRLockFilter_inst/lfReLockThrCounterRegA[*]
constrainNet /ljCDRLockFilter_inst/lfReLockThrCounterRegB[*]
constrainNet /ljCDRLockFilter_inst/lfReLockThrCounterRegC[*]
constrainNet /ljCDRLockFilter_inst/lfReLockThrCounterRegVotedA[*]
constrainNet /ljCDRLockFilter_inst/lfReLockThrCounterRegVotedB[*]
constrainNet /ljCDRLockFilter_inst/lfReLockThrCounterRegVotedC[*]
constrainNet /ljCDRLockFilter_inst/lfUnLockThrCounterRegA[*]
constrainNet /ljCDRLockFilter_inst/lfUnLockThrCounterRegB[*]
constrainNet /ljCDRLockFilter_inst/lfUnLockThrCounterRegC[*]
constrainNet /ljCDRLockFilter_inst/lfUnLockThrCounterRegVotedA[*]
constrainNet /ljCDRLockFilter_inst/lfUnLockThrCounterRegVotedB[*]
constrainNet /ljCDRLockFilter_inst/lfUnLockThrCounterRegVotedC[*]
constrainNet /ljCDRLockFilter_inst/lockedCountA[*]
constrainNet /ljCDRLockFilter_inst/lockedCountB[*]
constrainNet /ljCDRLockFilter_inst/lockedCountC[*]
constrainNet /ljCDRLockFilter_inst/lockedCountVotedA[*]
constrainNet /ljCDRLockFilter_inst/lockedCountVotedB[*]
constrainNet /ljCDRLockFilter_inst/lockedCountVotedC[*]
constrainNet /ljCDRLockFilter_inst/lossOfLockCountA[*]
constrainNet /ljCDRLockFilter_inst/lossOfLockCountB[*]
constrainNet /ljCDRLockFilter_inst/lossOfLockCountC[*]
constrainNet /ljCDRLockFilter_inst/lossOfLockCountVotedA[*]
constrainNet /ljCDRLockFilter_inst/lossOfLockCountVotedB[*]
constrainNet /ljCDRLockFilter_inst/lossOfLockCountVotedC[*]
constrainNet /ljCDRLockFilter_inst/nextLockedA
constrainNet /ljCDRLockFilter_inst/nextLockedB
constrainNet /ljCDRLockFilter_inst/nextLockedC
constrainNet /ljCDRLockFilter_inst/nextLockedCountA[*]
constrainNet /ljCDRLockFilter_inst/nextLockedCountB[*]
constrainNet /ljCDRLockFilter_inst/nextLockedCountC[*]
constrainNet /ljCDRLockFilter_inst/nextLockedCountVotedA[*]
constrainNet /ljCDRLockFilter_inst/nextLockedCountVotedB[*]
constrainNet /ljCDRLockFilter_inst/nextLockedCountVotedC[*]
constrainNet /ljCDRLockFilter_inst/nextLockedVotedA
constrainNet /ljCDRLockFilter_inst/nextLockedVotedB
constrainNet /ljCDRLockFilter_inst/nextLockedVotedC
constrainNet /ljCDRLockFilter_inst/nextLossOfLockCountA[*]
constrainNet /ljCDRLockFilter_inst/nextLossOfLockCountB[*]
constrainNet /ljCDRLockFilter_inst/nextLossOfLockCountC[*]
constrainNet /ljCDRLockFilter_inst/nextLossOfLockCountVotedA[*]
constrainNet /ljCDRLockFilter_inst/nextLossOfLockCountVotedB[*]
constrainNet /ljCDRLockFilter_inst/nextLossOfLockCountVotedC[*]
constrainNet /ljCDRLockFilter_inst/nextStateA[*]
constrainNet /ljCDRLockFilter_inst/nextStateB[*]
constrainNet /ljCDRLockFilter_inst/nextStateC[*]
constrainNet /ljCDRLockFilter_inst/nextStateVotedA[*]
constrainNet /ljCDRLockFilter_inst/nextStateVotedB[*]
constrainNet /ljCDRLockFilter_inst/nextStateVotedC[*]
constrainNet /ljCDRLockFilter_inst/nextUnLockedCountA[*]
constrainNet /ljCDRLockFilter_inst/nextUnLockedCountB[*]
constrainNet /ljCDRLockFilter_inst/nextUnLockedCountC[*]
constrainNet /ljCDRLockFilter_inst/nextUnLockedCountVotedA[*]
constrainNet /ljCDRLockFilter_inst/nextUnLockedCountVotedB[*]
constrainNet /ljCDRLockFilter_inst/nextUnLockedCountVotedC[*]
constrainNet /ljCDRLockFilter_inst/resetA
constrainNet /ljCDRLockFilter_inst/resetB
constrainNet /ljCDRLockFilter_inst/resetC
constrainNet /ljCDRLockFilter_inst/resetVotedA
constrainNet /ljCDRLockFilter_inst/resetVotedB
constrainNet /ljCDRLockFilter_inst/resetVotedC
constrainNet /ljCDRLockFilter_inst/stateA[*]
constrainNet /ljCDRLockFilter_inst/stateB[*]
constrainNet /ljCDRLockFilter_inst/stateC[*]
constrainNet /ljCDRLockFilter_inst/stateVotedA[*]
constrainNet /ljCDRLockFilter_inst/stateVotedB[*]
constrainNet /ljCDRLockFilter_inst/stateVotedC[*]
constrainNet /ljCDRLockFilter_inst/unLockedCountA[*]
constrainNet /ljCDRLockFilter_inst/unLockedCountB[*]
constrainNet /ljCDRLockFilter_inst/unLockedCountC[*]
constrainNet /ljCDRLockFilter_inst/unLockedCountVotedA[*]
constrainNet /ljCDRLockFilter_inst/unLockedCountVotedB[*]
constrainNet /ljCDRLockFilter_inst/unLockedCountVotedC[*]


    puts "TMRG successful  $tmrgSucces failed $tmrgFailed"
