package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import android.content.Context;
import android.util.Log;

import java.util.ArrayList;
import java.util.HashMap;

public class ListData1DataSheet extends DataSheet {

    public ListData1DataSheet(Context context) {
        super(context, "listData1");
        
        // This data sheet doesn't have local persistence enabled in Neonto Studio,
        // so write the default data each time.
        writeDefaultRowData();
    }
    
    @Override
    public String getName() {
        return "List data 1";
    }
    
    @Override
    protected void writeDefaultRowData() {
        ArrayList<HashMap<String, HashMap<String, Object>>> arr = new ArrayList<>();
        HashMap<String, HashMap<String, Object>> row;
        HashMap<String, Object> col;
        
        row = new HashMap<>();
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column2", col);
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column3", col);
        try {
            String json = "";
            Object obj = new org.json.JSONTokener(json).nextValue();
            col = new HashMap<>(); col.put("type", "json"); col.put("value", obj); row.put("list", col);
        } catch (Exception e) {
            Log.d("", "** could not load json object for data sheet key 'list'");
        }
        arr.add(row);
        row = new HashMap<>();
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column2", col);
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column3", col);
        try {
            String json = "";
            Object obj = new org.json.JSONTokener(json).nextValue();
            col = new HashMap<>(); col.put("type", "json"); col.put("value", obj); row.put("list", col);
        } catch (Exception e) {
            Log.d("", "** could not load json object for data sheet key 'list'");
        }
        arr.add(row);
        row = new HashMap<>();
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column2", col);
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column3", col);
        try {
            String json = "";
            Object obj = new org.json.JSONTokener(json).nextValue();
            col = new HashMap<>(); col.put("type", "json"); col.put("value", obj); row.put("list", col);
        } catch (Exception e) {
            Log.d("", "** could not load json object for data sheet key 'list'");
        }
        arr.add(row);
        row = new HashMap<>();
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column2", col);
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column3", col);
        try {
            String json = "";
            Object obj = new org.json.JSONTokener(json).nextValue();
            col = new HashMap<>(); col.put("type", "json"); col.put("value", obj); row.put("list", col);
        } catch (Exception e) {
            Log.d("", "** could not load json object for data sheet key 'list'");
        }
        arr.add(row);
        row = new HashMap<>();
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column3", col);
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column2", col);
        try {
            String json = "";
            Object obj = new org.json.JSONTokener(json).nextValue();
            col = new HashMap<>(); col.put("type", "json"); col.put("value", obj); row.put("list", col);
        } catch (Exception e) {
            Log.d("", "** could not load json object for data sheet key 'list'");
        }
        arr.add(row);
        row = new HashMap<>();
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column2", col);
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column3", col);
        try {
            String json = "";
            Object obj = new org.json.JSONTokener(json).nextValue();
            col = new HashMap<>(); col.put("type", "json"); col.put("value", obj); row.put("list", col);
        } catch (Exception e) {
            Log.d("", "** could not load json object for data sheet key 'list'");
        }
        arr.add(row);
        row = new HashMap<>();
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column2", col);
        col = new HashMap<>(); col.put("type", "text"); col.put("value", ""); row.put("column3", col);
        try {
            String json = "";
            Object obj = new org.json.JSONTokener(json).nextValue();
            col = new HashMap<>(); col.put("type", "json"); col.put("value", obj); row.put("list", col);
        } catch (Exception e) {
            Log.d("", "** could not load json object for data sheet key 'list'");
        }
        arr.add(row);
        
        mRows = arr;
    }

}
