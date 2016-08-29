package com.flowtoolz.paretospeak;

/**
 * Created by sfichtner on 28/09/15.
 */

public class DomainModel
{
    //region Singleton Access

    private static DomainModel sDomainModel = null;

    protected DomainModel()
    {
        initialize();
    }

    public static DomainModel getInstance()
    {
        if (sDomainModel == null)
        {
            sDomainModel = new DomainModel();
        }

        return sDomainModel;
    }

    //endregion

    //region Initialization

    private void initialize()
    {
        setHelloWorldGreen(false);
    }

    //endregion

    //region Hello World

    public void switchHelloWorldGreen()
    {
        setHelloWorldGreen(!isHelloWorldGreen());
    }

    public boolean isHelloWorldGreen()
    {
        return mHelloWorldGreen;
    }

    public void setHelloWorldGreen(boolean helloWorldGreen)
    {
        this.mHelloWorldGreen = helloWorldGreen;
    }

    private boolean mHelloWorldGreen;

    //endregion
}
