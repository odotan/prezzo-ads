
package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import android.app.Activity;
import android.app.ActionBar;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;

import com.neonto.exportedByUser_s2305552816857725.Prezzo.R;

public class PrezzoActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_prezzo);
        if (savedInstanceState == null) {
            getFragmentManager().beginTransaction()
                    .add(R.id.container, new PrezzoFragment())
                    .commit();
        }

        setTitle(getString(R.string.prezzo_title));
    }

    @Override
    protected void onStart() {
        super.onStart();
    }
}
