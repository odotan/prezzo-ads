package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import android.content.*;
import android.content.res.TypedArray;
import android.graphics.*;
import android.text.*;
import android.util.*;
import android.view.*;

public class CampaignBackgroundShapeView extends View {



    public CampaignBackgroundShapeView(Context context) {
        super(context);
        init(null, 0);
    }
    
    public CampaignBackgroundShapeView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(attrs, 0);
    }
    
    public CampaignBackgroundShapeView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(attrs, defStyle);
    }
    
    private void init(AttributeSet attrs, int defStyle) {
        // This method is just a stub that you can extend.
        // If you make this class styleable, you can load XML-declared
        // style attributes using getContext().obtainStyledAttributes().
        
        setLayerType(LAYER_TYPE_HARDWARE, null);
    }


    private int m_realLayoutWidthInPx;
    private int m_realLayoutHeightInPx;

    public void applyLayoutAndContentTransform(int w, int h, String contentTransform, float sc) {
        m_realLayoutWidthInPx = w;
        m_realLayoutHeightInPx = h;
    }
    
    @Override
    protected void onDraw(Canvas canvas) {
        Path path;
        Paint paint;
        
        super.onDraw(canvas);
        
        canvas.scale(m_realLayoutWidthInPx/638.0f, m_realLayoutHeightInPx/158.0f);
        canvas.translate(319.0f, 79.0f);
        path = new Path();
        path.moveTo(-319.0f, -79.0f);
          path.lineTo(319.0f, -79.0f);
        path.lineTo(319.0f, 79.0f);
        path.lineTo(-319.0f, 79.0f);
        
        path.close();
        paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setStyle(Paint.Style.FILL);
        paint.setARGB(255, 255, 255, 255);
        canvas.drawPath(path, paint);
    }

}
