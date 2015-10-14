package com.flowtoolz.paretospeak;

import android.content.Context;
import android.view.Gravity;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Created by sfichtner on 29/09/15.
 */

public class MainContentView extends RelativeLayout
{
    //region Initialization

    public MainContentView(Context context)
    {
        super(context);

        addChildren();
        layoutChildren();
    }

    private void addChildren()
    {
        // add hello world
        getHelloWorldTextView().setId(1);
        addView(getHelloWorldTextView());

        // add character button
        getCharacterButton().setId(2);
        addView(getCharacterButton());
    }

    private void layoutChildren()
    {
        // put character button below hello world
        RelativeLayout.LayoutParams params;
        params = (RelativeLayout.LayoutParams) getCharacterButton().getLayoutParams();

        params.addRule(RelativeLayout.BELOW, getHelloWorldTextView().getId());

        getCharacterButton().setLayoutParams(params);
    }

    //endregion

    //region Hello World Text View

    public TextView getHelloWorldTextView()
    {
        if (mHelloWorldTextView != null)
        {
            return mHelloWorldTextView;
        }

        // create
        mHelloWorldTextView = new TextView(this.getContext());

        // content
        updateHelloWorldTextView();

        // style
        mHelloWorldTextView.setText("Hello World"); // is not content when it's not dynamic
        mHelloWorldTextView.setGravity(Gravity.CENTER);
        mHelloWorldTextView.setPadding(30, 30, 30, 30);

        // minimal layout
        mHelloWorldTextView.setLayoutParams(defaultLayoutParams());

        return mHelloWorldTextView;
    }

    public void updateHelloWorldTextView()
    {
        DomainModel model = DomainModel.getInstance();

        if (model.isHelloWorldGreen())
        {
            mHelloWorldTextView.setBackgroundColor(0xFF00FF00);
        }
        else
        {
            mHelloWorldTextView.setBackgroundColor(0x00000000);
        }
    }

    private TextView mHelloWorldTextView;

    //endregion

    //region Character Button

    public Button getCharacterButton()
    {
        if (mCharacterButton != null)
        {
            return mCharacterButton;
        }

        // create
        mCharacterButton = new Button(this.getContext());

        // style
        mCharacterButton.setText("Switch Color");

        // minimal layout
        mCharacterButton.setLayoutParams(defaultLayoutParams());

        return mCharacterButton;
    }

    private Button mCharacterButton;

    //endregion

    //region Layout Tools

    private RelativeLayout.LayoutParams defaultLayoutParams()
    {
        return new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT);
    }

    //endregion
}
