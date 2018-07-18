function outcome_meas_strings=append_scale_factors(outcome_meas_strings,scale_factors)

ns=length(outcome_meas_strings);
for i=1:ns
   if scale_factors(i)~=1
       outcome_meas_strings{i}=[outcome_meas_strings{i} ' ( sf: ' num2str(scale_factors(i),'%10.e') ' )'];
   end
end

end