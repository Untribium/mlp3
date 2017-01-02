import numpy as np
import scipy.io as sio

from sklearn.ensemble import RandomForestClassifier

def main():

    features = 'X_7_40'
    path = 'src/features/'

    X_train = sio.loadmat(path+features+'_0.mat')[features+'_0']
    X_test = sio.loadmat(path+features+'_1.mat')[features+'_1']
    Y = sio.loadmat(path+'Y.mat')['Y']

    print('feature set', ':', features)

    params = ({
        'n_estimators'      : 250,
        'max_features'      : 500,
        'class_weight'      : 'balanced',
        'max_depth'         : 7,
        'min_samples_split' : 8,
        'min_samples_leaf'  : 3,
        'random_state'      : 2,
    })

    rfc = RandomForestClassifier(**params)

    print('fitting...')

    rfc.fit(X_train, Y)

    print('predicting...')

    prd = rfc.predict(X_test)

    print('==========================')

    for i in prd:
        print(i[0])
        print(i[1])
        print(i[2])

    print('==========================')


if __name__ == '__main__':
   main()
