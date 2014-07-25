% Name: James Keary 
% Student ID: N12432851 
% NetID: jpk349 
% Due Date: 2/15/2012
% Assignment: Binaural Convolver (Extra Credit)
% 
% Binaural convolver
%   reads in data files of HRFT and convolves with stereo signal of your
%   choice.  The resulting signal will be written to a .wav file.
%
% Inputs:
%
%   1) IRfilename : Name of data file containing the left impulse response
%   2) SIGfilename : Name of .wav file containing a signal 
%   3) OUTfile : Name of .wav file to which the resulting (convolved) signal 
%       will be written

function binauralconv2( IRfilename, SIGfilename, OUTfile )

% ---------- CONSTANTS AND EQUATIONS ----------

% reads compact data files and splits it into stereo channels
	fp = fopen(IRfilename,'r','ieee-be');
	data = fread(fp, 256, 'short');
	fclose(fp);

	leftimp = data(1:2:256);
    rightimp = data(2:2:256);

    irLength = length(leftimp);
    
% The function reads the .WAV file, converts to mono, and normalizes to prevent clipping

    [signal,fs] = wavread(SIGfilename);
    signal = mean(signal,2);
    signal = signal / 1.001 * max(abs(signal));
    sigLength = length(signal);

% allocate a matrix!

    outputMtx = zeros((irLength + sigLength -1), 2);
    
% convolve

    
    leftimpFFT = fft(leftimp, (sigLength + irLength) - 1);
    rightimpFFT = fft(rightimp, (sigLength + irLength) - 1);
    sigFFT = fft(signal, (sigLength + irLength) - 1);
         
    leftVec = ifft(leftimpFFT .* sigFFT);
    rightVec = ifft(rightimpFFT .* sigFFT);
    
% normalize and place vectors into matrix. 

    outputMtx(:,1) = leftVec / (1.0001 * max(abs(leftVec)));
    outputMtx(:,2) = rightVec / (1.0001 * max(abs(rightVec)));
 
% wavwrite

wavwrite (outputMtx, fs, OUTfile);

end
