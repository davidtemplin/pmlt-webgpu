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
cat src/wgsl/lib/chain.wgsl;
echo "\n";
cat src/wgsl/lib/scene.wgsl;
echo "\n";
cat src/wgsl/lib/light.wgsl;
echo "\n";
cat src/wgsl/lib/material.wgsl;
echo "\n";
cat src/wgsl/lib/path.wgsl;
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
JS="$(echo "$JS" | sed -e "s/#include post_connect_camera_direct.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/post_connect_camera_direct.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_camera_indirect.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/post_connect_camera_indirect.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_light_direct.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/post_connect_light_direct.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_light_indirect.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/post_connect_light_indirect.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include post_connect_null.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/post_connect_null.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include build_pdf.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/build_pdf.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include distribute.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/distribute.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include restart.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/restart.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include start_chain.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/start_chain.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include update_chain.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/update_chain.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include sample_material.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/sample_material.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include contribute.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/contribute.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"
JS="$(echo "$JS" | sed -e "s/#include connect.wgsl/\n\${wgslLib}\n\n$(cat src/wgsl/shaders/compute/auxiliary/connect.wgsl| sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"

HTML="$(cat src/html/main.html | sed -e "s/<!-- #include main.js -->/$(echo "$JS" | sed -e 's/[\&/]/\\&/g' -e 's/$/\\n/' | tr -d '\n')/g"; echo "\n")"

echo "$HTML" > build/main.html