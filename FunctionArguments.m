function [inargs,outargs] = FunctionArguments(fun)
% [inargs,outargs] = FunctionArguments(fun)
% Returns the first valid set of input and output arguments found in the
% help comments of function fun.
% Input arguments:
%   fun [string or function handle]
% Output arguments:
%   inargs [cell array of strings]
%   outargs [cell array of strings]

if isa(fun, 'function_handle')
    fun = func2str(fun);
end

assert(ischar(fun), 'FunctionArguments:FunNotAFunction', 'Input fun must be a function handle or a string.')
assert(exist(fun,'file')>0||exist(fun,'builtin')>0, 'FunctionArguments:FunNotFound', 'Function "%s" could not be found in the current path.', fun)

helpstr = help(fun);

assignmentStrs = regexpi(helpstr, ['[\[]?(?<outputs>[\w,\s]*)[\]]?\s*=\s*' fun '(?<inputs>((\s+)|(\([\w,\s]*\))))'], 'names');
assert(~isempty(assignmentStrs), 'FunctionArguments:InvalidHelpInputComments', 'Function "%s" had no identifiable example function calls in the HELP comments.')
%assignmentStrs = regexprep(assignmentStrs, '[\(\)\[\]\s]', '');
assignmentStrs = assignmentStrs(1);
% if isempty(regexp('\w+', assignmentStrs.inputs, 'ONCE'))
%     inargs = {};
% else
inargs = assignmentStrs.inputs;
inargs = regexprep(inargs, '[\(\)]', '');
inargs = strtrim(strsplit(inargs, ','));
if all(cellfun(@isempty, inargs))
    inargs = {};
end
%end
outargs = strtrim(strsplit(assignmentStrs.outputs,','));

inargs = inargs(:);
outargs = outargs(:);

% inargs = regexpi(helpstr, ['=\s*' fun '((\s+)|(\([\w,\s]*\)))'], 'match');
% assert(~isempty(inargs), 'FunctionArguments:InvalidHelpInputComments', 'Function "%s" had no identifiable input arguments specified.')
% if ~any(strcmp(inargs{1}, '('))
%     inargs = {};
% else
%     inargs = regexprep(inargs, '[\(\)\s=]', '');
%     inargs = strtrim(strsplit(inargs{1}, ','));
% end
% 
% outargs = regexpi(helpstr, ['[\[]?[\w,\s]*[\]]?\s*=\s*' fun '((\()|(\s))'], 'match');
% outargs = regexprep(outargs, '[\[\]\s=]', '');
% outargs = strsplit(outargs{1}, ',');

end