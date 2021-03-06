        .extern fb_width
        .extern fb_height
        .extern fb_stride
        .extern fb_bpp
        .extern _gfx_fgcol
        .extern _gfx_bgcol
        .extern framebuffer

        .global gfx_clear_packed
gfx_clear_packed:
        movl    framebuffer, %eax
        movzwl  fb_stride, %ecx
        movzwl  fb_height, %edx
        imull   %ecx, %edx
        addl    %eax, %edx
        pushl   %ebx
        movzwl  fb_bpp, %ebx
        movl    _gfx_bgcol, %ecx
.L1:
        movl    %ecx, (%eax)
        addl    %ebx, %eax
        cmpl    %eax, %edx
        ja      .L1
.L2:
        popl    %ebx
        ret

        .global gfx_hline
gfx_hline:
        pushl   %ebx
        movl    8(%esp), %eax
        movl    12(%esp), %ecx
        cmpl    %eax, %ecx
        jge     .L3
        xchgl   %eax, %ecx
.L3:
        movzwl  fb_stride, %edx
        movzbl  fb_bpp, %ebx
        imull   16(%esp), %edx
        addl    framebuffer, %edx
        imull   %ebx, %ecx
        imull   %ebx, %eax
        addl    %edx, %eax
        addl    %ecx, %edx
        movl    _gfx_fgcol, %ecx
        cmpl    %edx, %eax
        jnb     .L5
.L4:
        movl    %ecx, (%eax)
        addl    %ebx, %eax
        cmpl    %eax, %edx
        ja      .L4
.L5:
        popl    %ebx
        ret

        .global gfx_vline
gfx_vline:
        pushl   %esi
        pushl   %ebx
        movl    12(%esp), %eax
        movl    16(%esp), %edx
        cmpl    %eax, %edx
        jge     .L6
        xchgl   %eax, %edx
.L6:
        movzwl  fb_stride, %ebx
        movzbl  fb_bpp, %ecx
        imull   20(%esp), %ecx
        movl    framebuffer, %esi
        imull   %ebx, %edx
        imull   %ebx, %eax
        addl    %ecx, %eax
        addl    %edx, %ecx
        leal    (%esi,%ecx), %edx
        addl    %esi, %eax
        movl    _gfx_fgcol, %ecx
        cmpl    %edx, %eax
        jnb     .L8
.L7:
        movl    %ecx, (%eax)
        addl    %ebx, %eax
        cmpl    %eax, %edx
        ja      .L7
.L8:
        popl    %ebx
        popl    %esi
        ret

        .global gfx_drawpixel_32bpp
gfx_drawpixel_32bpp:
        movzwl  fb_stride, %eax
        movl    framebuffer, %edx
        imull   8(%esp), %eax
        movl    _gfx_fgcol, %ecx
        addl    4(%esp), %eax
        movl    %ecx, (%edx,%eax,4)
        ret
