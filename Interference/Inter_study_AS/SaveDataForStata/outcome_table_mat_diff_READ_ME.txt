outcome_table_diff.mat  %Contains the difference of the parameters A2-A1

dimensions	        (16x13)

first dimension		single event (8 subjects x 2 groups = 16) %Rows 17:32 are empty

second dimension:

	'dataPert1'	%First point
	'dataPert1_5'	%Average SLA 1:5
	'dataRate6_30'  %Average SLA 6:30	
	'dataSSL30'	%Average SLA last 30
	'fitPert1'	%First point of single exponential fit
	'fitPert1_5'	
	'fitRate6_30'	
	'fitSSL30'	
	'stridesToAVGpert' %Number of strides to reach 0.5*(SLA_1 + SLA_end), computed on fit data	
	'group'            %INTERFERENCE=1, SAVINGS=2
	'subject'	
	'condition'	
	'ID'
