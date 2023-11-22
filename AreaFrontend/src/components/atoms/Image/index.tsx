import React from 'react';
import './index.scss';
import ContentLoader from "react-content-loader";

interface ImageProps {
  src?: string;
  alt?: string;
  width: number;
  height: number;
}

const Image: React.FC<ImageProps> = ({
  src,
  alt,
  width,
  height
}) => {
  return (
    <div className="Image" style={{width, height}}>
      {src
        ? <img src={src} alt={alt} />
        : <ContentLoader
            speed={2}
            width={width}
            height={height}
            viewBox={`0 0 ${width} ${height}`}
            backgroundColor="#f3f3f3"
            foregroundColor="#ecebeb"
          >
          <rect x="0" y="0" rx="0" ry="0" width={width} height={height} />
          </ContentLoader>
      }
    </div>
  );
};

export default Image;
