%%% general input
animals = {'KIC02','KIC03','KIC04','KIC10','KIC11','KIC12','KIC13','KIC14','KIC15','KIC16'};

% ruled out:
% KIC01 - recording very messy, no detectable signal
% KIC05,06,07,and 08 underwent the same issue under anesthesia and died
%       before laser presentation
% KIC09 survived but had time periods where it was apparently brain dead
% problem determined to be related to ketamine anesthesia through ruling everything else out)


%% Channels and Layers

%   '[31; 15; 29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7; 18;  6; 19;  8; 17;  5]'
channels = {...
    '[27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4]',... %C 2
    '[15; 29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24]',... %C 3
	'[29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10]',... %C 4
    '[27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22]',... %C 10
    '[25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7]',... %C 11
    '[29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10]',... %C 12
	'[29; 13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10]',... %C 13
    '[27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4]',... %KIC 14
    '[13; 27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22]',... %KIC 15
	'[27; 11; 25;  9; 32; 16; 28;  1; 30; 14; 23;  2; 26; 12; 21;  3; 24; 10; 20;  4; 22;  7; 18;  6; 19]',... %KIC 16
    };

%              C:2      3           4           10          11          12          13          14          15 			16           
Layer.I_II = {'[1:3]',  '[1:3]',    '[1:3]',    '[1:3]',    '[1:4]',    '[1:4]',    '[1:3]',    '[1:3]',    '[1:3]',	'[1:3]'}; 
%              C:2      3           4           10          11          12          13          14          15
Layer.IV = {'[4:10]',   '[5:9]',    '[4:9]',    '[4:10]',   '[5:11]',   '[5:10]',   '[4:10]',   '[4:10]',   '[4:10]',	'[4:11]'};
%              C:2      3           4           10          11          12          13          14          15
Layer.V = {'[11:15]',   '[10:14]',  '[10:15]',  '[11:16]',  '[12:15]',   '[11:14]',  '[11:14]', '[11:14]',  '[11:15]',	'[12:18]'};
%              C:2      3           4           10          11          12          13          14          15
Layer.VI = {'[16:20]',  '[15:19]',  '[16:20]',  '[17:21]',  '[16:20]',  '[15:20]',  '[15:20]',  '[15:20]',  '[16:21]',	'[19:24]'}; 



%% Conditions
Cond.Pre = {... % tonotopies during baseline recording, 1 hour 
    {'0002','0003','0004','0005','0006','0007','0008','0009'},... %KIC 2
    {'0005','0006','0007','0008','0009','0010','0011','0012'},... %KIC 3
    {'0004','0005','0006','0007','0008','0009','0010','0011'},... %KIC 4
    {'0003','0004','0005','0006','0007','0008','0009','0010'},... %KIC 10
    {'0002','0003','0004','0005','0006','0007','0008','0009'},... %KIC 11
    {'0002','0003','0004','0005','0006','0007','0008','0009'},... %KIC 12
    {'0002','0003','0004','0005','0006','0007','0008','0009'},... %KIC 13
	{'0001','0002','0003','0004','0005','0006','0007','0008'},... %KIC 14
	{'0003','0004','0005','0006','0007','0008','0009','0010'},... %KIC 15
	{'0002','0003','0004','0005','0006','0007','0008','0009'},... %KIC 16
    };

Cond.preAM = {... % Amplitude modulation measurement, 10 minutes
    {'0010'},... %KIC 2
    {'0013'},... %KIC 3
    {'0012'},... %KIC 4
    {'0011'},... %KIC 10
    {'0010'},... %KIC 11
    {'0010'},... %KIC 12
    {'0010'},... %KIC 13
    {'0009'},... %KIC 14
    {'0011'},... %KIC 15
	{'0010'},... %KIC 16
    };

Cond.preAMtono = {... % tonotopies recorded after AM, 30 minutes
    {'0011','0012','0013','0014'},... %KIC 2
    {'0014','0015','0016','0017'},... %KIC 3
    {'0013','0014','0015','0016'},... %KIC 4
    {'0012','0013','0014','0015'},... %KIC 10
    {'0011','0012','0013','0014'},... %KIC 11
    {'0011','0012','0013','0014'},... %KIC 12
    {'0011','0012','0013','0014'},... %KIC 13
	{'0010','0011','0012','0013'},... %KIC 14
	{'0012','0013','0014','0015'},... %KIC 15
	{'0011','0012','0013','0014'},... %KIC 16
	};

Cond.preCL = {... % click train measurement, 10 minutes
    {'0015'},... %KIC 2
    {'0018'},... %KIC 3
	{'0017'},... %KIC 4
    {'0016'},... %KIC 10
    {'0015'},... %KIC 11
    {'0015'},... %KIC 12
    {'0015'},... %KIC 13
    {'0014'},... %KIC 14
    {'0016'},... %KIC 15
	{'0015'},... %KIC 16
    };

Cond.preCLtono = {... % tonotopies recorded after CL, 30 minutes
    {'0016','0017','0018','0019'},... %KIC 2
    {'0019','0020','0021','0022'},... %KIC 3
	{'0018','0019','0020','0021'},... %KIC 4
    {'0017','0018','0019','0020'},... %KIC 10
    {'0016','0017','0018','0019'},... %KIC 11
    {'0016','0017','0018','0019'},... %KIC 12
    {'0016','0017','0018','0019'},... %KIC 13
    {'0015','0016','0017','0018'},... %KIC 14 
    {'0017','0018','0019','0020'},... %KIC 15
	{'0016','0017','0018','0019'},... %KIC 16
    };

Cond.spPre1 = {... % spontaneous recording before laser, ~2 minutes
    {[]},... %KIC 2
    {'0023'},... %KIC 3
	{'0022'},... %KIC 4
    {'0021'},... %KIC 10
    {'0020'},... %KIC 11
    {'0020'},... %KIC 12
    {'0020'},... %KIC 13
    {'0019'},... %KIC 14
    {'0021'},... %KIC 15
	{'0020'},... %KIC 16
    };

 % LASER presentation, 20 seconds, 5 mW power, 477 nm light
 
Cond.spPost1= {... % spontaneous recording after laser, ~2 minutes
    {[]},... %KIC 2
    {'0024'},... %KIC 3
	{'0023'},... %KIC 4
    {'0022'},... %KIC 10
    {'0021'},... %KIC 11
    {'0021'},... %KIC 12
    {'0021'},... %KIC 13
    {'0020'},... %KIC 14
    {'0022'},... %KIC 15
	{'0021'},... %KIC 16
    };

Cond.CL = {... % click train recordings, 1 hour
    {'0020','0021','0022','0023'},... %KIC 2
    {'0025','0026','0027','0028'},... %KIC 3
	{'0024','0025','0026','0027'},... %KIC 4
    {'0023','0024','0025','0026'},... %KIC 10
    {'0022','0023','0024','0025'},... %KIC 11
    {'0022','0023','0024','0025'},... %KIC 12
    {'0022','0023','0024','0025'},... %KIC 13
    {'0021','0022','0023','0025'},... %KIC 14
    {'0023','0024','0025','0026'},... %KIC 15
	{'0022','0023','0024','0025'},... %KIC 16
    };

Cond.CLtono = {... % tonotopy recording, 7.5 minutes
    {'0025'},... %KIC 2
    {'0029'},... %KIC 3
	{'0028'},... %KIC 4
    {'0027'},... %KIC 10
    {'0026'},... %KIC 11
    {'0026'},... %KIC 12
    {'0026'},... %KIC 13
    {'0026'},... %KIC 14
    {'0027'},... %KIC 15
	{'0026'},... %KIC 16
    };

Cond.spPre2 = {... % spontaneous recording before laser, ~2 minutes
    {[]},... %KIC 2
    {'0030'},... %KIC 3
	{'0029'},... %KIC 4
    {'0028'},... %KIC 10
    {'0027'},... %KIC 11
    {'0027'},... %KIC 12
    {'0027'},... %KIC 13
    {'0027'},... %KIC 14
    {'0028'},... %KIC 15
	{'0027'},... %KIC 16
    };

 % LASER presentation, 20 seconds, 5 mW power, 477 nm light
 
Cond.spPost2= {... % spontaneous recording after laser, ~2 minutes
    {[]},... %KIC 2
    {'0031'},... %KIC 3
	{'0030'},... %KIC 4
    {'0029'},... %KIC 10
    {'0028'},... %KIC 11
    {'0028'},... %KIC 12
    {'0028'},... %KIC 13
    {'0028'},... %KIC 14
    {'0029'},... %KIC 15
	{'0028'},... %KIC 16
    };

Cond.AM = {... % amplitude modulation recordings, 1 hour
    {'0026','0027','0028','0029'},... %KIC 2
    {'0032','0033','0034','0035'},... %KIC 3
	{'0031','0032','0033','0034'},... %KIC 4
    {'0030','0031','0032','0033'},... %KIC 10
    {'0029','0030','0031','0032'},... %KIC 11
    {'0029','0030','0031','0032'},... %KIC 12 
    {'0029','0030','0031','0032'},... %KIC 13
    {'0029','0030','0031','0032'},... %KIC 14
    {'0030','0031','0032'},... %KIC 15 - animal died here under anesthesia
	{'0029','0030','0031','0032'},... %KIC 16
    };

Cond.AMtono = {... % tonotopy recording, 7.5 minutes
    {[]},... %KIC 2 %missed
    {'0036'},... %KIC 3
	{'0035'},... %KIC 4
    {'0034'},... %KIC 10
    {'0033'},... %KIC 11
    {'0034'},... %KIC 12
    {'0033'},... %KIC 13
    {[]},... %KIC 14 - not converting
    {[]},... %KIC 15
	{'0033'},... %KIC 16
    };

Cond.spEnd = {... % spontaneous recording, ~2 minutes
    {[]},... %KIC 2
    {'0037'},... %KIC 3
	{'0036'},... %KIC 3
    {'0035'},... %KIC 10
    {'0034'},... %KIC 11
    {'0035'},... %KIC 12
    {'0034'},... %KIC 13
    {'0034'},... %KIC 14 
    {[]},... %KIC 15
	{'0034'},... %KIC 16
    };
