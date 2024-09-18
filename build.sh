LIB=`
cat src/wgsl/lib/constants.wgsl;
echo "\n";
cat src/wgsl/lib/types.wgsl;
echo "\n";
cat src/wgsl/lib/data.wgsl;
echo "\n";
cat src/wgsl/lib/random.wgsl;
echo "\n";
cat src/wgsl/lib/util.wgsl;
echo "\n";
cat src/wgsl/lib/camera.wgsl;
echo "\n";
cat src/wgsl/lib/queue.wgsl;
echo "\n";
cat src/wgsl/lib/image.wgsl;
echo "\n";
`

JS="$(cat src/js/main.js)"
JS="$(echo "$JS" | sed -e "s/#include lib.wgsl/\n$(echo "$LIB" | sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include initialize.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/initialize.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include dispatch.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/dispatch.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include clear_queue.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/clear_queue.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include sample_camera.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/primary/sample_camera.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include sample_light.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/primary/sample_light.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include intersect.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/primary/intersect.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include build_cdf.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/build_cdf.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"


HTML="$(cat src/html/main.html | sed -e "s/<!-- #include main.js -->/$(echo "$JS" | sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"

echo "$HTML" > build/main.html