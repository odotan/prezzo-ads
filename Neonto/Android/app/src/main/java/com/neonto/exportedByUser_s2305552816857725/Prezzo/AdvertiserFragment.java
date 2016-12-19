package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class AdvertiserFragment extends Fragment {

    private AdvertiserView mView;

    public AdvertiserFragment() {  // fragment must have a constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        mView = new AdvertiserView(this);

        return mView;
    }

}
