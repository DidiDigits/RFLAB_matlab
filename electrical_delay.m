function tau_thru = electrical_delay(s11_thru, freq)
% Calculate Electrical Delay of a Connector Using S11 Measurement
%
% Inputs:
%   s11_thru : Measured S11 data (complex), vector
%   freq     : Frequency vector (Hz), same length as s11_thru
%
% Output:
%   tau_thru : Electrical delay of the connector in seconds

% Constants
KNOWN_SHORT_DELAY = 3.1785e-11;  % Known short delay (seconds)

omega = 2*pi*freq;
phase_s11 = angle(s11_thru);  % Phase in radians
phase_unwrapped = unwrap(phase_s11);

% Fit a line to UNWRAPPED phase vs. ANGULAR frequency
p = polyfit(omega, phase_unwrapped, 1);
tau_total = -p(1)/2;  % Correct delay calculation (round trip -> one way)

tau_thru = tau_total - KNOWN_SHORT_DELAY;  % Thru's electrical delay

% % Verification plots (uncomment to use)
% figure;
% subplot(2,1,1);
% plot(freq/1e6, phase_unwrapped, 'b-');
% hold on;
% plot(freq/1e6, polyval(p, omega), 'r--');
% xlabel('Frequency (MHz)'); ylabel('Phase (rad)');
% title('Unwrapped Phase with Linear Fit');
% legend('Measured', 'Fitted Line');
% 
% subplot(2,1,2);
% plot(freq/1e6, phase_s11, 'g.');
% xlabel('Frequency (MHz)'); ylabel('Phase (rad)');
% title('Original Wrapped Phase');

% fprintf('Calculated thru delay: %.2f ps\n', tau_thru*1e12);

end