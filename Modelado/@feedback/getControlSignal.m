function signal = getControlSignal(this,kalman, desiredState)
    signal = -K*(kalman.getAttitudeState() - desiredState);
end
