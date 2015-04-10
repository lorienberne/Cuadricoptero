function signal = getControlSignal(this, kalman, desiredState)
    signal = -this.K*(kalman.getState() - desiredState);
end
