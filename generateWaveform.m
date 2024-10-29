%%% This code generates an arbitraty waveform and sends it to Keysight 33622A 

%%% Reference: Measurement and Analysis of Human Body [Taewook Kang]
clear all; close all; clc;

sRate=1e9; %%Sample rate of the arb waveform 33622 max frequency 1 GSa/s

Aw=2;   %Amplitude
f0=1e6;     %start frequency
f1=10e6;    %stop frequency

step=1/sRate;

%%% Chirp
tchirp=[0:step:100e-6];
T=100e-6;   %Time to sewwp from f0 to f1
c=(abs(f1-f0))/T; 

schirp=Aw*sin(2*pi*(((c/2).*tchirp.^2)+f0.*tchirp));
arb=schirp
plot(tchirp,arb);

name='arb';

senToarbgen33600A(arb,Aw,sRate,name)