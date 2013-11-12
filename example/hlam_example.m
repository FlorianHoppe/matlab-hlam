%% HLAM



%% Basic Configuration
%
% The HLAM package uses a central configuration object to setup and store
% networks. This will be referred to as the |app| structure. The |app|
% structure contains the initial configuration of a learning environment,
% as well as the resulting network after running the algorithm.
%
% Examples of configurations and useful training and test data sets are
% available in |example/networks.mat|.



%%
% *Type of Learning Algorithm*
%
% Two essentially different learning methods are available. Offline
% learning processes a complete set of data in one go. Online learning
% feeds one sample at a time to the network using a different adaption
% strategy.

%%
% * |app.learningAlgorithmType| String, either |'online'| or |'offline'|.



%%
% *Data Sample Specification*
%
% Data sets are organized in N x D matrices containing N samples of D
% dimensions, i.e. samples are handled as row-vectors. The meaning of
% components may differ within a sample and must be specified using the
% |app.dataSample| substructure.

%%
% * |dataSample.domainSpaceIndices| Index or vector of indices of
% components containing domain space data.
%
% * |dataSample.modelSpaceIndices| Index or vector of indices of components
% containing model space data.
%
% * |dataSample.outputIndices| Index or vector of indices of components
% used to store results when evaluating a network.
%
% * |dataSample.targetOutputIndices|  Index or vector of indices of
% components containing desired network output, used for comparison with
% actual results.
%
% * _[ Optional ]_ |dataSample.discreteOutputIndices| Index or vector of
% indices specifying those output indices that are supposed to contain
% integer values. This is achieved by rounding the results during
% post-processing.

%%
% *Important note:* While |outputIndices| specifies indices regarding the
% actual sample, |discreteOutputIndices| specifies indices of
% |outputIndices|.
%
% E.g., consider the following setup:

dataSample.outputIndices         = [ 2 4 5 ];
dataSample.discreteOutputIndices = [ 1   3 ];

%%
% Here, only the results in components 2 and 5 of a sample will contain
% integer values.



%% Network Configuration
%
% Further details are configured using the |app.netInfo| substructure.

%%
% * |netInfo.domainType| String, either |'CD'| (center domain), |'HED'|
% (hyper-ellipsoid domain) or |'SVM'| (SVM domain).
%
% * |netInfo.orderOfPolynom| Integer.
%
% * |netInfo.maxError| Real number. During learning, experts will be added
% until the overall approximation error drops below this number.
%
% * |netInfo.nFoldCrossValidation| Integer.
%
% * |netInfo.rejectOutliers| Flag, set to |1| to activate. If set, the
% algorithm will throw an error in case an outlier is detected, instead of
% handling it gracefully.
%
% * |netInfo.relativeActivationGatingLaw| Flag, set to |1| to activate.


%%
% *SVM Domain*
%
% Using support vector domains requires additional settings:

%%
% * |netInfo.domainParameters.muForGaussianSVMKernel|
%
% * |netInfo.domainParameters.nu|



%%
% *Smoothing*

%%
% * |netInfo.withSmoothing| Flag, set to |1| to activate.

%%
% If smoothing is activated, additional flags are available:

%%
% * |netInfo.smoothingWithStrictMatchingScore|
%
% * |netInfo.smoothingWithNeighborhoodGraph|



%%
% *Expert Evaluation*

%%
% * |netInfo.onlyMaxScoreDecision| Flag, set to |1| to activate. If set,
% modifies the criterion how to determine the best matching expert.
%
% * |netInfo.maxScoreDecisionForOutliers| Flag, set to |1| to activate.
% Modifies outlier detection mechanism.



%%
% *Online Learning*
%
% A few settings are only used for online learning.

%%
% * |netInfo.sizeOfHistoryBuffer| Integer, number of samples to collect
% before old samples will be dropped in favor of newer ones.
%
% * |netInfo.minTrainSamples| Integer, number of samples to collect, before
% adding a new expert. Should be less or equal to |sizeOfHistoryBuffer|
% (will be enforced otherwise).
%
% * |netInfo.numOfSamplePassedForOnlineFusion| Integer, number of samples
% after which fusion is applied to experts. *Note:* This setting will be
% used only by |generateNet(...)| and ignored when manually calling
% |updateNet(...)|.



%% Selection Criterion Functions
%
% *Settings*
%
% During online learning, experts may repeatedly be fused and redundant
% models removed. The algorithm's behaviour can be controlled by using a
% specific selection criterion.

%%
% * |netInfo.fuseCriterion| Function pointer, an implementation of a
% selection criterion function.

%%
% Several criteria are already supplied in the 'criteria' subdirectory,
% such as:

%%
% * |@selectionCriterionAll|
%
% * |@selectionCriterionMin|
%
% * |@selectionCriterionMax|
%
% * |@selectionCriterionMinMax|
%
% * |@selectionCriterionAbsMax|
%
% * |@selectionCriterionClusterMaxSamples|
%
% * |@selectionCriterionClusterMaxNeighbors|



%%
% *Implementing your own Selection Criterion*
%
% You can provide your own selection criterion by simply using a function
% handle to your own implementation.
%
% To integrate seamlessly, your function is required to take the |app|
% structure as an argument and return an N x 2 matrix of pairs of expert
% ids that are selected to be fused.



%% Generating the Network
%
% After configuring the |app| structure, you can finally create the network
% using problem specific training data. Obviously, this data must conform
% to your data sample specification (see above).

app = generateNet(app, trainData);

%%
% This will leave your settings untouched and add the following fields to
% the |app| structure:

%%
% * |app.net| Structure, describes the generated network.

%%
% The network is described by the following fields of the |app.net|
% substructure:

%%
% * |net.timeNeededForTraining| Time used for the training process in
% seconds.
%
% * |net.neighborhoodGraph| Matrix, if set, it is the weighted adjacency
% matrix of the neighborhood graph that was used in the most recent trial
% to remove redundant models.

%%
% * |net.experts| Cell array, a column of expert substructures, see below
% for details.
%
% * |net.gatingNeurons| Matrix, containing the neurons of all experts
% storing one neuron per row.
%
% * |net.neuronToExpertMap| Column vector, index lookup to match neurons in
% the |gatingNeuron| collection to their respective experts. This is
% necessary in case there are fused experts which have more than one
% neuron.



%%
% *Offline*

%%
% * |net.meanTrainingErrorOfExperts|
%
% * |net.stdTrainingErrorOfExperts|



%%
% *Online*

%%
% * |net.unusedTrainData| N x D matrix of samples, collecting training data
% of single samples before being fed to the algorithm. Maybe empty after
% learning.
%
% * |net.badPerformanceAlthoughBelongsTo| Number of samples which produced
% an approximation error above |app.netInfo.maxError| although they have
% already been matched with the domain of the best performing expert (this
% results in updating that expert).



%% The Expert Structure
%
% An |expert| structure contains several fields describing the expert.

%%
% * |expert.trainData| Matrix, in standard data set dimensions. Contains
% the training data as used in the last update.
%
% * |expert.numOfTrainingSamples| Integer, number of samples in the afore
% mentioned data set.
%
% * |expert.C| Coefficient matrix from linear regression.
%
% * |expert.allTrainingErrors|
%
% * |expert.meanTrainingError|
%
% * |expert.stdTrainingError|
%
% * |expert.neuron| Row vector.
%
% * |expert.domainModel| A substructure describing the domain model, see
% below for details.

%%
% In case the |expert| structure resulted from fusing two experts, the
% |expert.neuron| and |expert.domainModel| fields are replaced by the
% fields |expert.neurons| and |expert.domainModels| respectively.



%%
% *Center Domain*
%
% No specific fields are set for experts using an center domain model.



%%
% *Hyper-Ellipsoid Domain*
%
% The following fields provide detailed information about the domain model
% if the expert uses an hyper-ellipsoid domain.

%%
% * |domainModel.eigenSpace|
%
% * |domainModel.position|
%
% * |domainModel.variance|
%
% * |domainModel.minDistance|



%%
% *SVM Domain*
%
% The following fields provide detailed information about the domain model
% if the expert uses an SVM domain.

%%
% * |domainModel.SVM|
%
% * |domainModel.SVM.supportVectors|
%
% * |domainModel.SVM.alphas|
%
% * |domainModel.minDistance|
%
% * |domainModel.sparseness|



%% Evaluating an Experiment
%
% After constructing the net using specific training data, you may want to
% evaluate its quality using appropriate test data. To evaluate your
% experiment, call

ex = evaluateExperiment(app, testData);

%%
% or, to have the results plotted,

ex = evaluateExperiment(app, testData, 1);

%%
% *Note:* Only the first two components of the gating input data and the
% neurons will be used in the plot. Also, if the |app| structure has been
% configured to use the offline algorithm, it is required to have
% |app.image.width| and |app.image.height| set to reasonable values which
% will affect the display.

%%
% The resulting |ex| structure contains several fields describing the
% results.

%%
% * |ex.app| This is the initial configuration that you provided.
%
% * |ex.app.net| Consequently, the generated net is also included.

%%
% *Note:* It should be obvious that the |ex| structure contains all
% relevant information about your experiment. Thus, it is the only variable
% you need to save in case you want to continue working with this
% experiment.

%%
% *Approximation Error*
%
% Several fields containing statistical information about the net's
% approximation error are available.

%%
% * |ex.ME|
%
% * |ex.std|
%
% * |ex.MSE|
%
% * |ex.nMSE|
%
% * |ex.RMSE|
%
% * |ex.maxE|
%
% * |ex.nMSE|

%%
% *Note:* |ex.nMSE| is only available if exactly one target ouput index is
% set in the data sample specification (one-dimensional output).



%%
% *Usage of Experts*
%
% The number of experts that have been activated for any individual sample
% can be retrieved from the |matchingExpertsPerSample| vector:

%%
% * |ex.matchingExpertsPerSample( indexOfSample )|

%%
% The number of times each individiual expert has been activated can be
% retrieved from the |usageOfExperts.hits| vector:

%%
% * |ex.usageOfExpert.hits( expertId )|

%%
% Finally, several fields containing global statistical information about
% the experts' usage are available.

%%
% * |ex.usageOfExpert.maxHits|
%
% * |ex.usageOfExpert.minHits|
%
% * |ex.usageOfExpert.medianHits|
%
% * |ex.usageOfExpert.meanHits|
%
% * |ex.usageOfExpert.numOfNotUsed| (not activated by any sample)

