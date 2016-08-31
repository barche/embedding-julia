result = ""
for (i,arg) in enumerate(ARGS)
  if !startswith(arg, "-I")
    result *= arg * " "
  end
end

print(result[1:end-1])
