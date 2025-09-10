shader_type canvas_item;

// original colors (normalized) — #EAE6DA and #CDBFB3
uniform vec4 old_fur_color       : source_color = vec4(0.917647, 0.9020, 0.854902, 1.0);
uniform vec4 old_shadow_color    : source_color = vec4(0.803922, 0.74902, 0.7020, 1.0);

// replacements (set from GDScript)
uniform vec4 new_fur_color       : source_color = vec4(1.0, 0.8, 0.6, 1.0);
uniform vec4 new_shadow_color    : source_color = vec4(0.7, 0.5, 0.3, 1.0);

// how close a pixel must be to count as "old color"
uniform float tolerance = 0.06;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // default output = original texture color
    vec4 out_color = tex_color;

    // skip very transparent pixels
    if (tex_color.a >= 0.1) {
        float d_fur = distance(tex_color.rgb, old_fur_color.rgb);
        if (d_fur < tolerance) {
            // match fur
            out_color = vec4(new_fur_color.rgb, tex_color.a);
        } else {
            float d_shadow = distance(tex_color.rgb, old_shadow_color.rgb);
            if (d_shadow < tolerance) {
                // match shadow
                out_color = vec4(new_shadow_color.rgb, tex_color.a);
            }
        }
    }

    COLOR = out_color;
}

//void vertex() {
	//// Called for every vertex the material is visible on.
//}
//
//void fragment() {
	//// Called for every pixel the material is visible on.
//}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
