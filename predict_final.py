import numpy as np
import scipy.io as sio

from sklearn.ensemble import RandomForestClassifier

def main():

    features = 'X_17_20_2k'
    path = 'src/features/'

    X_train = sio.loadmat(path+features+'_0.mat')[features+'_0']
    X_test = sio.loadmat(path+features+'_1.mat')[features+'_1']
    Y = np.ravel(sio.loadmat(path+'Y.mat')['Y'])

    params = ({
        'n_estimators' : 100,
        'min_samples_split' : 3,
        'min_samples_leaf' : 2,
        'max_depth' : 6,
        'max_features' : 200,
        'class_weight' : {0:3.0, 1:1},
        'random_state' : 19
    })

    rfc = RandomForestClassifier(**params)

    rfc.fit(X_train, Y)

    Y_prob = rfc.predict_proba(X_test)

    print(Y_prob[:, 1])


if __name__ == '__main__':
   main()
