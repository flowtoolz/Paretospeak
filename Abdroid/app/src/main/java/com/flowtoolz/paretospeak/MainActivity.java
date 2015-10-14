package com.flowtoolz.paretospeak;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

public class MainActivity extends AppCompatActivity
{
    //region Life Cycle

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        setContentView(getContentView());

        connectCharacterButtonTap();
    }

    //endregion

    //region Logic

    private void connectCharacterButtonTap()
    {
        View.OnClickListener tapListener = new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                characterButtonTapped();
            }
        };

        getContentView().getCharacterButton().setOnClickListener(tapListener);
    }

    private void characterButtonTapped()
    {
        switchHelloWorldColor();
    }

    private void switchHelloWorldColor()
    {
        DomainModel model = DomainModel.getInstance();

        model.switchHelloWorldGreen();

        getContentView().updateHelloWorldTextView();
    }

    //endregion

    //region Content View

    private MainContentView getContentView()
    {
        if (mContentView != null)
        {
            return mContentView;
        }

        // create
        mContentView = new MainContentView(this);

        return mContentView;
    }

    private MainContentView mContentView;

    //endregion
}
