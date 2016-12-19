
package com.neonto.exportedByUser_s2305552816857725.Prezzo;

import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.v13.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.neonto.exportedByUser_s2305552816857725.Prezzo.R;

public class TabsFragment extends Fragment {

    /**
     * The {@link android.support.v4.view.PagerAdapter} that will provide
     * fragments for each of the sections. We use a
     * {@link FragmentPagerAdapter} derivative, which will keep every
     * loaded fragment in memory. If this becomes too memory intensive, it
     * may be best to switch to a
     * {@link android.support.v13.app.FragmentStatePagerAdapter}.
     */
    TabsFragmentPagerAdapter mPagerAdapter;

    /**
     * The {@link ViewPager} that will host the section contents.
     */
    ViewPager mViewPager;

    public TabsFragment() {  // fragment must have a constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View rootView = inflater.inflate(R.layout.fragment_tabs, container, false);
        
        final ActionBar actionBar = ((ActionBarActivity) getActivity()).getSupportActionBar();
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
        actionBar.setDisplayShowHomeEnabled(false);
        actionBar.setDisplayShowTitleEnabled(false);

        mPagerAdapter = new TabsFragmentPagerAdapter(getFragmentManager());

        mViewPager = (ViewPager) rootView.findViewById(R.id.tabs_viewpager);
        mViewPager.setAdapter(mPagerAdapter);

        mViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageSelected(int i) {
                actionBar.setSelectedNavigationItem(i);
                switch (i) {
                    case 0: getActivity().setTitle("me"); break;
                    case 1: getActivity().setTitle("prezzo"); break;
                    case 2: getActivity().setTitle("notifications"); break;
                }

            }

            @Override
            public void onPageScrolled(int i, float v, int i2) {
            }

            @Override
            public void onPageScrollStateChanged(int i) {
            }
        });
        
        ActionBar.Tab tab;
        
        tab = actionBar.newTab()
                .setText("Profile")
                .setIcon(R.drawable.tabs_fragment_tab_icon0)
                .setTabListener(new TabListener(mViewPager));
        actionBar.addTab(tab);
        
        tab = actionBar.newTab()
                .setText("Around me")
                .setIcon(R.drawable.tabs_fragment_tab_icon1)
                .setTabListener(new TabListener(mViewPager));
        actionBar.addTab(tab);
        
        tab = actionBar.newTab()
                .setText("notifications")
                .setIcon(R.drawable.tabs_fragment_tab_icon2)
                .setTabListener(new TabListener(mViewPager));
        actionBar.addTab(tab);
        
        
        try {
            String action = getActivity().getIntent().getAction();
            java.util.Set<String> categories = getActivity().getIntent().getCategories();
            if (action == android.content.Intent.ACTION_MAIN && categories != null && categories.contains(android.content.Intent.CATEGORY_LAUNCHER)) {
                // Default page when the app starts.
                mViewPager.setCurrentItem(1);
            } else {
                Bundle bundle = getActivity().getIntent().getExtras();
                final int tabIndex = bundle.getInt("tabIndex");
                mViewPager.setCurrentItem(tabIndex);
            }
        } catch (Exception e) {}

        return rootView;
    }

    /**
     * A {@link FragmentPagerAdapter} that returns a fragment corresponding to
     * one of the sections/tabs/pages.
     */
    public class TabsFragmentPagerAdapter extends FragmentPagerAdapter {

        public TabsFragmentPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
                        
            switch (position) {
            case 0:
                return new MeFragment();
            case 1:
                return new PrezzoFragment();
            case 2:
                return new NotificationsFragment();
            }
            return null;

        }

        @Override
        public int getCount() {
            return 3;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return "";
        }
    }
    
    public static class TabListener implements ActionBar.TabListener {
        private ViewPager mViewPager;
        
        public TabListener(ViewPager viewPager) {
            mViewPager = viewPager;
        }
        
        public void onTabSelected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction ft) {
            mViewPager.setCurrentItem(tab.getPosition());
        }
        
        public void onTabUnselected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction ft) {
        }
        
        public void onTabReselected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction ft) {
        }
    }

}
