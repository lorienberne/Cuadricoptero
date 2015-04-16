function signal = getControlSignal(this, kalman,state, desiredState)
    signal = -this.K*(state - desiredState);
end
