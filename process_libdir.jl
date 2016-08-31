for (i,arg) in enumerate(ARGS)
  if startswith(arg, "-L")
    print(arg[3:end])
    break
  end
end
