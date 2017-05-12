import React, { PropTypes } from 'react';
import { JobItem, SubHeading } from 'components';
import { Wrapper, List} from './styles';
import Infinite from 'react-infinite';

const propTypes = {
  jobs: PropTypes.array.isRequired,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired
};

const JobList = ({jobs, total, handleSwitchFavoriteStatus, handleLoad}) =>{
  console.log(total)
  return (
    <Wrapper>
      <SubHeading>{`${total} startups`}</SubHeading>
      <Infinite
        infiniteLoadBeginEdgeOffset={10}
        onInfiniteLoad={handleLoad}
        containerHeight={1500}
        elementHeight={150}
        preloadBatchSize={Infinite.containerHeightScaleFactor(2)}
        useWindowAsScrollContainer
      >
      {renderJobRows(jobs, handleSwitchFavoriteStatus)}
      </Infinite>
    </Wrapper>
  )
};

function renderJobRows(jobs, fnc) {
  return (
    <List>
      {
        jobs.map((job, index) => {
          const property = {...job, index, handleSwitchFavoriteStatus: fnc};
          return <JobItem key={job.id} {...property} />
        })
      }
    </List>
  )
}

JobList.propTypes = propTypes;
export default JobList;