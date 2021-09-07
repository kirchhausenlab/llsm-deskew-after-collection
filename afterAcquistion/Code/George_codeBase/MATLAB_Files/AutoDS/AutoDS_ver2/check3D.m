function flag = check3D(Ex_directory)

Meta = getMeta2(Ex_directory);

if Meta.planes > 1
    flag = true;
else
    flag = false;
end


end