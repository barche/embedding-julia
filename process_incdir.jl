for (i,arg) in enumerate(ARGS)
  if startswith(arg, "-I")
    print(arg[3:end])
    break
  end
end
