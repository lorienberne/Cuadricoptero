function signal = getControlSignal(this, kalman, desiredState)
    signal = -this.K*(desiredState - kalman.getState() );
end
