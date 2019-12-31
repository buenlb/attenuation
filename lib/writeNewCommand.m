function writeNewCommand(fid,value,commandName)

fprintf(fid,['\\newcommand{\\',commandName,'}{',num2str(value,2),'}\n']);