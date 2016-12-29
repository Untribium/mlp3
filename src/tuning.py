import numpy as np
import scipy.io as sio

from sklearn.ensemble import RandomForestClassifier
from sklearn.grid_search import GridSearchCV
from sklearn import cross_validation, metrics

def main():

    features = 'X_17_20_2k'
    path = 'features/'

    X_train = sio.loadmat(path+features+'_0.mat')[features+'_0']
    X_test = sio.loadmat(path+features+'_1.mat')[features+'_1']
    Y = np.ravel(sio.loadmat(path+'Y.mat')['Y'])

    params = ({
        'n_estimators' : [100],
        'min_samples_split' : [3],
        'min_samples_leaf' : [2],
        'max_depth' : [6],
        'max_features' : [200],
        'class_weight' : [{0:3.0, 1:1}],
        'random_state' : [19]
    })

    gsearch = GridSearchCV(estimator = RandomForestClassifier(), param_grid = params, scoring='neg_log_loss', n_jobs=-1, iid=False, cv=17)

    gsearch.fit(Xtrain, Y)

    print(features)
    print(gsearch.best_params_)
    print(gsearch.best_score_)


if __name__ == '__main__':
   main()
