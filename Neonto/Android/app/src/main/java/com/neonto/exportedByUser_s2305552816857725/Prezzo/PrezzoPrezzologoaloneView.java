package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import android.content.*;
import android.content.res.TypedArray;
import android.graphics.*;
import android.graphics.drawable.Drawable;
import android.text.*;
import android.util.*;
import android.view.*;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class PrezzoPrezzologoaloneView extends FrameLayout {



    private ImageView m_image;
    // This value represents scaling applied to the image by Neonto Studio on export.
    private float m_contentOriginalScale = 1.0f;
    

    private boolean m_imageOverriden = false;

    public PrezzoPrezzologoaloneView(Context context) {
        super(context);
        init(null, 0);
        createViews(context);
    }
    
    public PrezzoPrezzologoaloneView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(attrs, 0);
        createViews(context);
    }
    
    public PrezzoPrezzologoaloneView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(attrs, defStyle);
        createViews(context);
    }
   
    private void init(AttributeSet attrs, int defStyle) {
    }

    private void createViews(Context context) {
        ImageView imageView;
        Drawable d = null;
        
        imageView = new ImageView(context);
        d = getResources().getDrawable(R.drawable.prezzo_prezzologoalone);
        imageView.setImageDrawable(d);
        imageView.setScaleType(ImageView.ScaleType.FIT_XY);
        imageView.setLayerType(LAYER_TYPE_HARDWARE, null);
        this.addView(imageView);
        m_image = imageView;
        
        applyLayoutAndContentTransform(720, 1280, null, 1.0f);  // default; will be reset by fragment
    }

    // This method does all the dirty work of fitting the image content into a layout rectangle
    // according to a matrix from Neonto Studio. The matrix represents the image's transforms
    // (crops, rotations, etc.) applied by the user.
    // 
    // The 'layoutSc' value is the current screen format's pixel scale to the screen format's
    // default. (E.g. a Galaxy S6 uses the 720p screen format with a 2.0 layoutScale.)
    //
    public void applyLayoutAndContentTransform(int layoutW, int layoutH, String contentTransformMatrices, float layoutSc) {
        if (m_imageOverriden) {
            updateOverridenImageLayout();
            return;
        }

        Matrix matrix = null;
        String trsStr = contentTransformMatrices;
        if (contentTransformMatrices != null) {
            int idx = contentTransformMatrices.indexOf(";");
            if (idx != -1) {
                trsStr = contentTransformMatrices.substring(idx + 1);
            }
        }
        if (trsStr != null) {
            int idx = trsStr.indexOf("[");
            if (idx != -1) {
                trsStr = trsStr.substring(idx+1);
            }

            float[] mat = new float[6];
            for (int i = 0; i < 6; i++) {
                String s = trsStr;
                idx = s.indexOf(",");
                if (idx != -1) {
                    s = s.substring(0, idx);
                    trsStr = trsStr.substring(idx+1).trim();
                } else {
                    idx = s.indexOf("]");
                    if (idx != -1) s = s.substring(0, idx);
                }
                try {
                    mat[i] = Float.valueOf(s);
                } catch (Exception e) {
                    Log.d("ImageClip", "can't parse transform matrix at "+i+": "+e);
                    break;
                }
                if (i == 5) {
                    Log.d("ImageClip", String.format("matrix: %f, %f, %f, %f, %f, %f", mat[0], mat[1], mat[2], mat[3], mat[4], mat[5]));

                    matrix = new Matrix();
                    float v[] = new float[9];
                    matrix.getValues(v);
                    v[Matrix.MSCALE_X] = mat[0] / m_contentOriginalScale;
                    v[Matrix.MSKEW_X] = -mat[1] / m_contentOriginalScale;
                    v[Matrix.MSKEW_Y] = -mat[2] / m_contentOriginalScale;
                    v[Matrix.MSCALE_Y] = mat[3] / m_contentOriginalScale;
                    v[Matrix.MTRANS_X] = mat[4];
                    v[Matrix.MTRANS_Y] = mat[5];
                    matrix.setValues(v);
                }
            }
        }

        Drawable d;
        ViewGroup.LayoutParams lp;
        int contentW, contentH;
        float sc, contentSc;
        
        d = m_image.getDrawable();
        if (d == null)
            return;
        
        int imgW = d.getIntrinsicWidth();
        int imgH = d.getIntrinsicHeight();
        
        contentW = 540;
        contentH = 714;
        contentSc = (float)imgW / contentW;
        sc = layoutSc / contentSc;
        
        lp = new FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        m_image.setLayoutParams(lp);
        if (matrix != null) {
            matrix.preScale(sc, sc);
            float v[] = new float[9];
            matrix.getValues(v);
            v[Matrix.MTRANS_X] *= layoutSc;
            v[Matrix.MTRANS_Y] *= layoutSc;
            matrix.setValues(v);
            
            m_image.setScaleType(ImageView.ScaleType.MATRIX);
            m_image.setImageMatrix(matrix);
        }

    }

    public void setImageDrawable(Drawable d) {
        if (d == null) {
            if (m_imageOverriden) {
                removeAllViews();
                m_imageOverriden = false;
    
                createViews(getContext());
            }
            return;
        }
    
        m_image.setImageDrawable(d);
        m_imageOverriden = true;
        updateOverridenImageLayout();
    }
    
    private void updateOverridenImageLayout() {
        Drawable d = m_image.getDrawable();
        int imgW = d.getIntrinsicWidth();
        int imgH = d.getIntrinsicHeight();
    
        ViewGroup.LayoutParams lp = getLayoutParams();
    
        int viewW = lp.width;
        int viewH = lp.height;
        m_image.setLayoutParams(new FrameLayout.LayoutParams(viewW, viewH));
    
        boolean cropTopBottom = true;
        boolean cropLeftRight = true;
    
        Matrix matrix = new Matrix();
    
        float asp = (imgH > 0) ? ((float)imgW / imgH) : 0;
        float dstAsp = (float)viewW / viewH;
        if ((cropTopBottom && cropLeftRight && asp >= dstAsp)
            || (!cropTopBottom && !cropLeftRight && asp < dstAsp)
            || (!cropTopBottom && cropLeftRight)) {
            float dstW = asp * viewH;
            float sc = dstW / imgW;
            matrix.setTranslate((viewW - dstW) / 2, 0);
            matrix.preScale(sc, sc);
        } else {
            float dstH = (float)viewW / asp;
            float sc = dstH / imgH;
            matrix.setTranslate(0, (viewH - dstH) / 2);
            matrix.preScale(sc, sc);
        }
    
        m_image.setScaleType(ImageView.ScaleType.MATRIX);
        m_image.setImageMatrix(matrix);
    }
    
    public Drawable getDrawable() {
        return m_image.getDrawable();
    }
    
}
