import numpy as np
import scipy.io as sio
import warnings

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import hamming_loss, make_scorer
from sklearn import metrics

# deprecation warnings
warnings.simplefilter("ignore")

# invert loss
def neg_hamming_loss(y_true, y_pred):
    return -hamming_loss(y_true, y_pred)

def main():

    features = 'X_7_40'
    path = 'features/'

    X_train = sio.loadmat(path+features+'_0.mat')[features+'_0']
    X_test = sio.loadmat(path+features+'_1.mat')[features+'_1']
    Y = sio.loadmat(path+'Y.mat')['Y']

    print('feature set', ':', features)

    # == RandomForest ==
    rfc = RandomForestClassifier()

    params = ({
        'n_estimators'      : [350],
        'max_features'      : [350],
        'class_weight'      : ['balanced'],
        'max_depth'         : [5],
        'min_samples_split' : [10],
        'min_samples_leaf'  : [2],
        'random_state'      : range(0,1),
    })

    gcv = GridSearchCV(estimator = rfc, param_grid = params, scoring=make_scorer(neg_hamming_loss), n_jobs=-1, iid=False, cv=17)

    print('fitting...')

    gcv.fit(X_train, Y)

    print('predicting...')

    prd = gcv.predict(X_test)

    if True:
        print('==========================')
        for i in prd:
            print(i[0])
            print(i[1])
            print(i[2])

    print('==========================')

    for r in sorted(gcv.cv_results_.keys()):
        if not r == 'params' and not r.startswith('split'):
            print(r, ':', gcv.cv_results_[r])

    print('params:')
    for i in range(0, len(gcv.cv_results_['params'])):
        print(gcv.cv_results_['params'][i], '| %.5f' % gcv.cv_results_['mean_test_score'][i], '| %.5f' % gcv.cv_results_['std_test_score'][i])

    print('==========================')

    print('cv mean', ':', gcv.best_score_)
    print('cv std', ':', gcv.cv_results_['std_test_score'][gcv.best_index_])
    print('feature set', ':', features)
    for p in gcv.best_params_:
        print(p, ':', gcv.best_params_[p])


if __name__ == '__main__':
   main()
